---
name: hardware-embedded
description: Stand up a firmware / embedded / microcontroller / robotics / IoT project in a project folder from the user's answers — toolchain set up, drivers and the main loop written, a power budget checked, and a guided flash-and-verify path onto the real board. A project-kit sub-skill loaded by new-project's routing whenever the user wants to BUILD firmware / an embedded system / a microcontroller, robotics, or IoT project, up toward aerospace (CubeSat-ish). The agent cannot wire or flash a board itself — it sets up the toolchain and guides the USER to connect, flash, and report back.
---

# hardware-embedded — build firmware, verify it on the real board

## What this sub-skill is for
Standing up an **embedded / firmware project**: pick a board and toolchain, write the
drivers and the main control loop, check the power budget, and walk the user through
**flashing it onto the real hardware and confirming it runs**. Loaded by `new-project`
for anything from a blinking ESP32 up to a small RTOS payload on an STM32 or a CubeSat-ish
build. **Hard reality:** this agent has no physical access — it cannot wire a breadboard,
plug in a board, or flash silicon. It prepares everything in software, then **hands the
flash + verify step to the user and waits for their report.** Verification on real hardware
is the only thing that closes a task.

## Mandatory grill-questions (fold into the Definition of Ready)
- **Target board / MCU:** ESP32 / STM32 / RP2040 / AVR-Arduino / nRF / — or a Linux SBC
  (Raspberry Pi)? Exact part, clock, flash/RAM size. (A Linux SBC is a different world than
  bare-metal — confirm which.)
- **Toolchain:** PlatformIO / Arduino CLI / ESP-IDF / Zephyr / STM32Cube / Rust `embassy`?
  Pick one and commit — the rest of the project hangs off it.
- **RTOS vs bare-metal:** super-loop, or FreeRTOS/Zephyr tasks? Timing/latency requirements?
- **Peripherals & protocols:** which sensors/actuators, and over what bus — I2C / SPI / UART
  / CAN / PWM / ADC? **Pinout and voltage levels per device** (3.3 V vs 5 V — matters).
- **Power budget:** supply (battery/USB/bus), current draw active vs sleep, duty cycle,
  expected runtime. (Critical for IoT/space; a wrong assumption here bricks the mission.)
- **Flash / debug path:** how is it programmed — USB-DFU / UART bootloader / SWD-JTAG via
  OpenOCD+GDB / J-Link / picotool / esptool? Is a debug probe on hand?
- **Connectivity:** BLE / WiFi / LoRa / Ethernet / none? OTA-update needed?

## Project sub-agents to generate (`.claude/agents/`)
- **firmware-builder** — implements the main loop / RTOS tasks and the build config for the
  chosen toolchain; gets a clean compile before reporting (delegate-by-default for firmware).
- **peripheral-driver-writer** — writes one sensor/actuator/bus driver at a time (register
  maps, init sequence, read/write) against the datasheet (delegate-by-default for drivers).
- **flash-runner** — does NOT flash anything itself; it prepares the exact flash command for
  the user's probe/board, **guides the user step-by-step to connect and flash**, then reads
  back their reported output/serial log to judge pass/fail. Confirms wiring before any flash.
- **power-budget-checker** — adversarial: sums current draw across modes/duty-cycle, checks
  it against the supply and runtime target, flags brown-out / regulator / battery-life risks.

## Tools / CLIs / MCP / skills needed
- The chosen toolchain CLI, surfaced and offered (never auto-installed): `platformio`
  (`pip install platformio`), `arduino-cli`, ESP-IDF (`idf.py`), `west` (Zephyr), or the Rust
  embedded toolchain (`rustup target add …`, `probe-rs`, `cargo-embed`).
- Flash/debug tools: `esptool`, `picotool`, `dfu-util`, `openocd` + `gdb-multiarch`,
  J-Link tools — plus a serial monitor (`pio device monitor`, `screen`, `minicom`) so the
  user can paste back what the board prints. On Linux, the udev/`dialout` group access hint.
- A logic check helps: optional logic-analyzer / oscilloscope capture the user can share.
- **Global skills/agents to chain:** `deep-research` (datasheets, errata, bring-up notes,
  reference designs), `code-review` (firmware correctness / ISR + buffer safety), `verify`
  (build + emulator/QEMU smoke where possible — but emulation never substitutes for the real
  board), `market-researcher` (agent) for facts on parts/modules/availability.

## File / asset nudges (on top of the base set)
- `HARDWARE.md` — board, MCU, the **confirmed pinout table** (pin → signal → device →
  voltage), buses, power source. Single source of truth for wiring; update before reflashing.
- `POWER.md` — the power budget: per-mode current, duty cycle, supply, expected runtime,
  margin.
- `firmware/` (or `src/`) with the toolchain's project layout; `platformio.ini` / `sdkconfig`
  / `CMakeLists.txt` / `Cargo.toml` as applicable.
- `drivers/` — one file per peripheral; `datasheets/` (or links) for each part.
- `FLASH.md` — the exact flash + monitor commands, the connect steps, and what a healthy
  boot log looks like, so the user can flash and report consistently.
- `firmware_backups/` — the last-known-good binary kept before every reflash. `.env.template`
  for any WiFi/cloud creds (never hard-coded in firmware source).

## Stack defaults & done-bar
**Default stack:** PlatformIO as the toolchain (broad board support, reproducible builds),
a super-loop unless the grill calls for an RTOS, drivers in `drivers/`, serial logging for
bring-up. Swap to ESP-IDF / Zephyr / `embassy` / Arduino CLI per the answers.
**Done-bar (all must hold):**
1. Firmware **builds clean** for the target with the chosen toolchain on a fresh checkout.
2. The user has **flashed it onto the real board** following `FLASH.md` (agent does not flash).
3. The **core loop and at least the key peripheral are verified ON HARDWARE** by the user —
   confirmed via serial log / observed behavior — not by simulation/emulation alone.
4. The power budget in `POWER.md` is computed and within the supply's margin.
5. A known-good binary is backed up in `firmware_backups/` before any reflash.

## Guardrails
- **Never assume wiring or pinout — confirm it with the user** before generating flash steps;
  a wrong pin or a 5 V signal into a 3.3 V pin can destroy a board.
- **Flag electrical-safety / voltage / current risks explicitly** (level shifting, brown-out,
  shorts, LiPo handling, mains anywhere) and stop for confirmation on anything that could
  damage hardware or harm the user.
- **Back up the working firmware before every reflash** — a bad flash can brick the device.
- **The agent cannot verify on hardware itself** — emulation/QEMU is a smoke test, never the
  proof. Real-hardware verification by the user is required to call any task done; say so when
  it hasn't happened yet.
- **Never claim a peripheral works without the user's on-hardware confirmation.** Mark
  unverified behavior as unverified.
- NO emojis in any firmware output, logs, or UI. Commits under the user's own name only
  (Skryx-L-A) — never add Claude as a co-author. Never commit secrets / WiFi or cloud
  credentials / API keys (use `.env.template` and runtime config, not hard-coded strings).
