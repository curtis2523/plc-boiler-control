import sys
import serial.tools.list_ports as lp
from nicegui import app, ui
from pymodbus.client import ModbusSerialClient

emergency_button = """
<svg height="100" width="100" xmlns="http://www.w3.org/2000/svg">
    <circle r="45" cx="50" cy="50" fill="red" />
    <text x="15" y="55" fill="black">EMERGENCY</text>
</svg>"""

class picoPLC:
    def __init__(self):
        self.comport = self.find_pico()
        self.connected = False
        self.inputs = []
        self.outputs = []
        self.temperature_steps = 0
        self.leds = [False] * 6
        self.working_led = False
        self.run_mode = False
        self.state = "STOP"

        if self.comport:
            try:
                self.PLC = ModbusSerialClient(port=self.comport, baudrate=115200)
                self.PLC.connect()
                self.connected = True
                print("✅ PLC connected.")
            except Exception as e:
                print(f"❌ PLC connection failed: {e}")

    def find_pico(self):
        for s in lp.comports():
            if s.vid == 0x2E8A and s.pid in [9, 10, 11, 15, 0xc0, 0xf00a]:
                return s.device
        return ""

    def readPLC(self):
        if not self.connected:
            return False
        try:
            rr = self.PLC.read_discrete_inputs(0, count=8, slave=1)
            self.inputs = rr.bits
            rr = self.PLC.read_coils(0, count=8, slave=1)
            self.outputs = rr.bits
            return True
        except:
            return False

    def update_temperature_leds(self):
        self.leds = [False] * 6
        step = self.temperature_steps
        if step == 0:
            return
        if step % 2 == 1:
            led_index = (step + 1) // 2 - 1
            if led_index < 6:
                self.leds[led_index] = True
        else:
            led_index = step // 2 - 1
            if led_index < 6:
                self.leds[led_index] = True
            if led_index + 1 < 6:
                self.leds[led_index + 1] = True

    def update_plc_outputs(self):
        if not self.connected:
            return
        try:
            data = self.leds + [self.working_led] + [False] * (8 - len(self.leds) - 1)
            self.PLC.write_coils(0, data, slave=1)
        except:
            pass

    def adjust_temperature(self, change):
        if not self.run_mode:
            new_val = max(0, min(11, self.temperature_steps + change))
            if new_val != self.temperature_steps:
                self.temperature_steps = new_val
                self.update_temperature_leds()
                self.update_plc_outputs()
                ui.notify(f"🌡️ Temperature adjusted to {80 + (self.temperature_steps - 1) * 10 if self.temperature_steps else 0}°C")

    def start_boiler(self):
        if self.connected and not self.run_mode and self.temperature_steps > 0:
            self.run_mode = True
            self.working_led = True
            self.state = "RUN"
            self.update_plc_outputs()
            ui.notify("🔥 Boiler Started!", type="positive")

    def stop_boiler(self):
        if self.connected and self.run_mode:
            self.run_mode = False
            self.working_led = False
            self.state = "STOP"
            self.update_plc_outputs()
            ui.notify("🛑 Boiler Stopped", type="warning")

    def emergency_stop(self):
        self.run_mode = False
        self.working_led = False
        self.temperature_steps = 0
        self.leds = [False] * 6
        self.state = "EMERGENCY"
        self.update_plc_outputs()
        ui.notify("🚨 EMERGENCY STOP", type="negative")

    def update_control(self):
        if not self.readPLC():
            return
        stop = self.inputs[0] if len(self.inputs) > 0 else False
        up = self.inputs[1] if len(self.inputs) > 1 else False
        emergency = self.inputs[2] if len(self.inputs) > 2 else False
        down = self.inputs[3] if len(self.inputs) > 3 else False
        start = self.inputs[6] if len(self.inputs) > 6 else False

        if emergency:
            self.emergency_stop()
        elif stop:
            self.stop_boiler()
        elif start:
            self.start_boiler()
        elif not self.run_mode:
            if up:
                self.adjust_temperature(1)
            elif down:
                self.adjust_temperature(-1)

    def close(self):
        if self.connected:
            self.PLC.close()

# ===== UI 定义 =====

@ui.refreshable
def ui_status():
    with ui.row().classes("items-center"):
        ui.label("🖥️ Status:").classes("font-bold")
        color = "text-gray-500"
        text = "⛔ STOPPED"
        if plc.state == "RUN":
            color, text = "text-green-600", "🔥 RUNNING"
        elif plc.state == "EMERGENCY":
            color, text = "text-red-600", "🚨 EMERGENCY"
        ui.label(text).classes(f"{color} font-bold")

        temp = 0 if plc.temperature_steps == 0 else 80 + (plc.temperature_steps - 1) * 10
        ui.label(f"🌡️ Temperature: {temp}°C").classes("ml-4 text-blue-700 font-bold")

@ui.refreshable
def ui_controls():
    with ui.row().classes("gap-4 items-center"):
        ui.button("▶ Start", on_click=plc.start_boiler).classes("bg-green-500 text-white")
        ui.button("■ Stop", on_click=plc.stop_boiler).classes("bg-yellow-500 text-white")
        ui.html(emergency_button).on("click", plc.emergency_stop)
        ui.button("⬆ Increase", on_click=lambda: plc.adjust_temperature(1)).classes("bg-blue-500 text-white")
        ui.button("⬇ Decrease", on_click=lambda: plc.adjust_temperature(-1)).classes("bg-blue-500 text-white")

@ui.refreshable
def ui_indicators():
    with ui.row().classes("gap-2 items-center"):
        ui.icon("🔴" if plc.working_led else "⚫").classes("text-4xl")
        for i, led in enumerate(plc.leds):
            ui.icon("🟢" if led else "⚫").tooltip(f"LED {i+1}").classes("text-4xl")

def update_ui():
    plc.update_control()
    ui_status.refresh()
    ui_indicators.refresh()
    ui_controls.refresh()

def build_ui():
    with ui.card().classes("w-full max-w-3xl p-6 bg-gray-100 shadow-lg rounded-xl"):
        with ui.row().classes("justify-between"):
            ui.label("🛠️ Boiler Control System").classes("text-2xl font-bold")
        ui_status()
        ui_indicators()
        ui_controls()

def on_shutdown():
    app.timer(0.5, update_ui, active=False)
    plc.close()

if __name__ in {"__main__", "__mp_main__"}:
    plc = picoPLC()
    if plc.connected:
        build_ui()
        app.on_shutdown(on_shutdown)
        app.timer(interval=0.5, callback=update_ui, active=True)
        ui.run(title="🔥 Boiler HMI", host="127.0.0.1", port=8080, reload=False)
    else:
        print("❌ No PLC detected.")
        sys.exit(1)
