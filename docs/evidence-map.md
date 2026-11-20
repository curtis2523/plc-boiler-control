# Evidence Map

## Source key

A1 through A4 refer to the four team report DOCX files under Automation and Embedded System / Assignment, Parts 1–4. The private manifest keeps the original filenames. Page numbers use local PDF renders.

| Claim | Source | Evidence |
| --- | --- | --- |
| Individual responsibilities | A1, A3 and A4 p. 1 each | Shared circuit, ladder and HMI work, documentation in Parts 1/3 and video in Part 4 |
| Logisim Evolution | A1 pp. 1–4 and original .circ | Counter, decoder, D flip-flop, operating-state gating and emergency reset |
| CircuitPython and PID | A2 report and Part 2 scripts | Separate lab |
| OpenPLC, LD and ST | A3 pp. 1–4, plc.xml, beremiz.xml and ST exports | CTUD, equality and OR logic, I/O names and export variants |
| Pico GPIO and indicators | A3 pp. 2–7 and Part3-Task2-Video.mp4 at 00:16 | Physical buttons and LEDs on the lab bench |
| Python, NiceGUI and UI state | A4 pp. 1–5 and main.py | Five handlers, local RUN/STOP/EMERGENCY, stepped setpoint and indicators |
| PyModbus and pySerial | A4 pp. 3–6 and main.py | Serial discovery, 115200 baud, unit 1, reads and attempted coil writes. The timer interval is 0.5 seconds |
| Write stability and status synchronization | A4 pp. 5–7 and main.py | Delayed and missed commands reported. The UI renders local state and the retained code does not check write responses |
| Report-only debug and retry fragments | A4 p. 6 versus main.py | The saved method has no success return, detailed write log or retry loop |
| Demonstrated outcome | A3 pp. 4–7 and A4 pp. 3–7 | Bench I/O and UI behaviors documented separately. No reliable bidirectional HMI actuation established |
