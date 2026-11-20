# Source Layout

| Path | Contents |
| --- | --- |
| [src/logisim](../src/logisim) | Original Logisim Evolution circuit, renamed for the repository |
| [src/openplc](../src/openplc) | OpenPLC Editor project and sanitized board settings reference |
| [src/openplc/st-exports](../src/openplc/st-exports) | Distinct IEC 61131-3 Structured Text exports, named by base or offset I/O addressing |
| [src/hmi](../src/hmi) | Original Python/NiceGUI HMI with the team-identifying UI label and title suffix removed |

The board settings example retains the device type, serial parameters and pin lists. It omits computer-specific and network settings. The retained ST variants differ in I/O addresses and logic details. The exact firmware/runtime and deployed export are unconfirmed.

The HMI's source imports NiceGUI, PyModbus and pySerial. The course archive does not establish exact dependency versions. The captured interface and bench behavior are documented in the [evidence map](evidence-map.md). Release preparation was limited to organizing artifacts and checking the repository content.
