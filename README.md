# SC2107-wijie

This repository is controlled by an AI agent to help its human operator prepare for the SC2107 Lab 5 assessment using a TI RSLK MAX robot.

Labs 1–4 are preparation for Lab 5, which assesses knowledge and practical work from Labs 1–4. Each lab's manual and briefing, along with related assessment material, is stored locally in the root `labs/` folder. This folder is excluded from Git and must be supplied separately on any other computer that needs the materials.

This conversation is used for debugging, code implementation, explanations, and assessment preparation. The agent should read the Lab 1–4 manuals and briefings to understand the required work and guide the human through it.

## Working workflow

```text
Mac (this device) <--> GitHub repository <--> Lab computer with CCS <--> RSLK MAX robot
```

The Mac has no direct connection to the robot. Git is used to transfer code between the Mac and the lab computer, where Code Composer Studio (CCS) builds, flashes, and debugs the robot firmware. Hardware behavior must be tested on the lab computer and robot, with observations and errors brought back to this conversation.

Before switching computers, commit and push the intended changes. On the other computer, pull those changes before opening or building the relevant CCS project. Commit and push any changes made in the lab before returning to the Mac.

## Collaboration preferences

For each lab, state how many main items need to be completed and briefly explain their purpose. Lab 2 has two main items: the GPIO reflectance driver (including line position calculation) and the finite state machine (FSM).

Prioritize code implementation, physical robot checks, and a clear overview of what is done and what remains. Assume the human already knows the fundamentals. After implementation, review the changes, show the relevant code, and explain what changed and why in simple, direct sentences. Distinguish checks performed on the Mac from results that still need verification on the robot.

Follow the lab manual and change only what is needed for the requested task. Do not add extra features or unrelated code changes.

Keep the Learning section updated whenever the human learns something, asks for an explanation, or resolves a debugging issue. Put each lesson under its lab and keep it simple and straightforward.

## Learning

### Lab 1

- Lab 1 covers CCS, debugging, GPIO inspection, embedded C, assembly, and linker memory layout.
- Most work is observation and debugging. The main coding task is the short `Convert` assembly routine.
- Build compiles and links the code. Debug loads the program onto the MSP432 and starts a debug session.
- A CCS error saying the project compiler is not installed is a toolchain setup issue, not evidence of a source-code error. These projects request legacy TI ARM compiler versions in the 16.9.x.LTS family.
- The Mac's CCS 21.0.1 installation was found to contain TI Arm Clang 5.1.1.LTS and an MSP430 compiler, but no legacy TI ARM compiler. MSP430 is not the MSP432's compiler, and TI Arm Clang is a different toolchain from legacy `armcl`.
- The current workflow still uses the Mac for editing and the lab computer for compilation, flashing, and robot debugging. Building on the Mac would require installing/discovering a suitable legacy ARM-CGT toolchain and validating the project against it. Do not switch the shared projects to Clang just to remove the missing-compiler warning; that is a separate migration.
- CCS import can modify project metadata and regenerate build files. Do not confuse those local IDE changes with intentional robot source changes.

### Lab 2

- Two main items: the GPIO reflectance driver and the FSM.
- Both main Lab 2 items are physically verified: the reflectance bit readings and the FSM's sensor-to-color behavior, including the line-lost cases.
- Turn on the robot's battery power. USB power to the LaunchPad alone does not confirm that the sensors are powered.
- `Data` contains eight sensor bits. `1` means black and `0` means white. The leftmost bit is P7.7 and the rightmost bit is P7.0.
- Example: `00011000` means the two center sensors, P7.4 and P7.3, detect black. All white gives `0x00`; all black gives `0xFF`.
- `Position` is the average position of sensors detecting black, in 0.1 mm units. Positive is toward the robot's right; negative is left.
- In the current code, both no line (`0x00`) and a symmetric reading such as `0x18` or `0xFF` give position zero. Check `Data` to distinguish them.
- Use the Debug build configuration in CCS. Clicking the Debug button does not switch a Release build to Debug.
- Put the verification breakpoint on `Clock_Delay1ms(10);`, after `Data` and `Position` update. Keep Skip All Breakpoints off.
- Do not pause or single-step during the sensor discharge measurement. Debugger delays change the reading.
- Declaring `int i;` before `for(i = 0; ...)` avoids the loop-declaration compatibility issue encountered on the lab computer.
- The FSM reads the center pair with `(Reflectance_Read(1000) >> 3) & 0x03`. Input bit 1 is P7.4 (left sensor); bit 0 is P7.3 (right sensor).
- FSM input `11` gives yellow (straight), `01` gives green (turn right), and `10` gives red (turn left). These LEDs simulate motors; the robot does not drive in this lab.
- State names describe the robot's position: Left means the robot is left of the line and must turn right. Right means it must turn left.
- Left of line = robot needs to steer right = left wheel forward/faster than the right wheel.
- A one-sensor reading should keep the correct turn, rather than alternate between turning and going straight. The turn must also switch directly if the opposite sensor detects black.
- When input is `00`, the FSM keeps its previous turn direction. If the previous state was Center, it defaults to turning left. This is a search choice, not a guarantee that the line will be found again.
- The state delay is 500 ms for visible LED testing. Reducing it to 10 ms makes the wait 50 times shorter and allows faster corrections. Sensor-read time and, in later labs, motor response also affect the behavior.

FSM color reference: only P7.3 and P7.4 affect the FSM. The other six sensors can be over black or white without changing its input.

| RGB color | FSM state | Center sensors over black | Meaning |
|---|---|---|---|
| Yellow (red + green) | Center | Both P7.3 and P7.4 | Line centered; simulate going straight. All eight over black also gives this result. |
| Green | Left | P7.3 only; P7.4 over white | Robot is left of the line; simulate turning right. |
| Red | Right | P7.4 only; P7.3 over white | Robot is right of the line; simulate turning left. |
| Green | Left | Neither, after Left/green | Line lost; keep searching right. |
| Red | Right | Neither, after Right/red or Center/yellow | Line lost; keep searching left, or start the default left search. |

All eight sensors over white gives input `00`, so the color depends on the previous state. These are the RGB LED colors; the separate red heartbeat LED is not the FSM output.

### Lab 3

- Three main items: SysTick sensor sampling, GPIO bump interrupts, and motor/PWM integration.
- The existing code already implements SysTick reflectance sampling, GPIO bump interrupts, and motor/PWM integration. Verify the existing code before making changes. Reflectance, all six bump sensors, and wheel movement have passed physical testing. Bump-triggered motor stopping has not been separately confirmed.
- SysTick runs every 1 ms. `Reflectance_Start()` charges the sensors at count 0; `Reflectance_End()` reads them at count 1. This repeats every 10 ms.
- The current sensor project is at section 6.3.2: bump switches use falling-edge Port 4 interrupts, not SysTick polling. The earlier section 6.3.1 bump-polling exercise is a separate stage.
- Reflectance bits use `1 = black`. Bump bits use `0 = pressed`, because the bump switches have pull-up resistors.
- `Bump_Read()` packs P4.0, P4.2, P4.3, P4.5, P4.6, and P4.7 into bits 0 through 5. No switches pressed gives `0x3F`; all six pressed gives `0x00`.
- Watch `reflectance_data`, `bump_data`, and `MainCount` in CCS. Let the program run with Continuous Refresh; do not pause between reflectance charging and reading.

| Switch pressed alone | GPIO pin | Bit cleared in `bump_data` | Expected binary | Hex |
|---|---|---|---|---|
| None, when sampled | — | None | `00111111` | `0x3F` |
| Bump0, robot's rightmost | P4.0 | Bit 0 | `00111110` | `0x3E` |
| Bump1 | P4.2 | Bit 1 | `00111101` | `0x3D` |
| Bump2 | P4.3 | Bit 2 | `00111011` | `0x3B` |
| Bump3 | P4.5 | Bit 3 | `00110111` | `0x37` |
| Bump4 | P4.6 | Bit 4 | `00101111` | `0x2F` |
| Bump5, robot's leftmost | P4.7 | Bit 5 | `00011111` | `0x1F` |

Pressing BumpX clears bit X to zero in the packed result; the other released switches remain one. Pressing several switches clears several bits. For example, Bump0 and Bump5 together give `00011110` (`0x1E`).

Bits 7 and 6 are always zero. These values describe the switch states when sampled. In the current interrupt version, `bump_data` holds the last press-event sample; release does not trigger a refresh. It also starts at zero until the first press event, so do not treat its initial zero as a live reading of all six switches.

For sensor verification, use `Lab3_Bump_Reflectance_Systick` with the Debug build, battery power on, no breakpoints, and Continuous Refresh in Expressions. Watch `reflectance_data`, `bump_data`, and `MainCount`. Check all eight reflectance bits and press each bump switch separately. `MainCount` should keep increasing.

Motor verification uses `Lab3_TimerCompare_Motor` with the Debug build, battery power on, and wheels supported clear of the table. Remove breakpoints and let the program run.

| Press and release LaunchPad SW1 or SW2 | Expected movement | Left wheel | Right wheel |
|---|---|---|---|
| First time | Forward, then stop | Forward | Forward |
| Second time | Backward, then stop | Backward | Backward |
| Third time | Turn left, then stop | Backward | Forward |
| Fourth time | Turn right, then stop | Forward | Backward |

Each movement lasts about one second. After stopping, the program waits for another LaunchPad button press and release. The sequence repeats after the fourth movement.

During movement, hold a bump switch: both wheels should stop when the 10 Hz check detects it, nominally within about 100 ms. Repeat for all six switches. The current code can resume motion on release if the one-second movement period has not ended; it does not latch an emergency stop. Do not use debugger Pause as the motor-stop test, because hardware PWM can continue while the CPU is halted.

- Motor speed mapping was corrected after the readiness review. Lab 3 manual Figure 8 maps P2.6/Timer_A0 CCR3 to the right wheel and P2.7/CCR4 to the left wheel. All four movement functions now send `rightDuty` to `PWM_Duty3()` and `leftDuty` to `PWM_Duty4()`.
- Equal duties such as `(3000,3000)` cannot reveal a left/right mapping error. Host register checks cover unequal duties in both orders, equal duties, and zero-duty cases for all four movement functions. Physical unequal-duty verification is pending.
- For a physical check, temporarily change the first forward call in `Lab3_Timersmain.c` to `Motor_Forward(4000,2000)`: the left wheel should run faster. Reverse it to `(2000,4000)`: the right wheel should run faster. Support the wheels clear of the table, use the existing one-second movement/button sequence, and restore `(3000,3000)` afterward.

### Lab 4

- Two main items: IR distance-sensor calibration through ADC and tachometer speed measurement through timer capture.
- ADC sampling and filtering are already provided in `Lab4_ADC_IRSensors`. `LeftConvert()`, `CenterConvert()`, and `RightConvert()` in `inc/IRDistance.c` now use the supplied calibration table with piecewise linear interpolation. Physical distance verification is pending.
- In CCS Expressions, watch `nl` (left, P9.1/ADC16), `nc` (center, P4.1/ADC12), and `nr` (right, P9.0/ADC17) in decimal. These are filtered ADC counts, not distances. The 14-bit ADC range is 0–16383.
- Use Debug configuration, battery power on, no breakpoints, and Continuous Refresh. Move a flat obstacle along each sensor's viewing direction and confirm the corresponding reading changes.
- For calibration, collect settled readings at 5 cm intervals from 5 to 50 cm for each sensor. Measure from the sensor face to the obstacle, not from the front of the robot. Each sensor must be measured separately at the same physical distances.
- The conversion functions return centimeters, rounded to the nearest whole centimeter. The existing UART prints left, center, and right distances in that order; `nl`, `nc`, and `nr` remain filtered ADC counts.
- Fit and verify each sensor separately using its measured data. Do not assume all three sensors share one calibration curve.
- Calibration data was supplied for this robot. Left and right use the 5-50 cm samples. Center uses only 10-50 cm: its ADC count rises from 13515 at 5 cm to 15728 at 10 cm, then falls. A single count can represent two distances, so the 5 cm center sample cannot be combined with the far-distance branch.
- Center ADC 13515 maps to about 12 cm on the selected far-distance branch, even though it was also observed at 5 cm. Do not use this center conversion below 10 cm. ADC values outside each table's endpoints are clamped to the nearest supported distance, not extrapolated.
- Most left/right points are estimates, not measurements. They are included as supplied, but matching these table values in software does not prove physical accuracy. Verify all three sensors with a ruler, especially 20 cm, and replace estimated points with measured values when possible.

Calibration table (`*` means estimated; all unmarked points were supplied as measured):

| Distance (cm) | Center `nc` | Right `nr` | Left `nl` |
|---|---|---|---|
| 5 | 13515 (excluded from center conversion) | 14000 | 14780 |
| 10 | 15728 | 13427 | 13740 |
| 15 | 10582 | 9106* | 9060* |
| 20 | 7575 | 6581* | 6326* |
| 25 | 5666 | 4978* | 4590* |
| 30 | 4734 | 4195 | 3742 |
| 35 | 3845 | 3448* | 2934* |
| 40 | 3251 | 2950* | 2393* |
| 45 | 2977 | 2720* | 2144* |
| 50 | 2722 | 2505* | 1912* |

For distance verification, build and debug `Lab4_ADC_IRSensors` in Debug configuration with battery power on. Open the XDS110 Application/User UART serial port at 115200 baud, 8 data bits, no parity, 1 stop bit, and no flow control. Run without breakpoints and compare the printed left/center/right distances with a ruler at 10, 20, 30, 40, and 50 cm, measuring each sensor separately from its face along its viewing direction.

CCS serial Terminal steps:

1. Keep the robot connected by USB. In Windows, right-click Start, open Device Manager, and expand Ports (COM & LPT).
2. Find `XDS110 Class Application/User UART (COMx)` and note its COM number. Do not select the Auxiliary Data Port.
3. In CCS, open View > Terminal. In that panel, click Open a Terminal (hover over the small toolbar icons to identify it).
4. Choose Serial Terminal and the COM number from Device Manager. Set baud rate 115200, data bits 8, parity None, stop bits 1, and flow control None. Click OK.
5. Build/debug `Lab4_ADC_IRSensors`, turn on battery power, remove breakpoints, and click Resume. Text should update about once a second; the printed order is left, center, right.
6. Place a flat obstacle 20 cm from one sensor's face along its viewing direction. Check its matching printed value, then repeat separately for the other sensors and distances.
7. A blank Terminal is a connection/run issue to check first. Recheck the COM number, connected Terminal status, and whether the processor is Running. Close any other program using that COM port. Garbled text suggests a baud-rate or clock-setting mismatch.

- Tachometer/RPM code is implemented; physical verification is pending. Right wheel uses P10.4/Timer_A3 CCR0 (`Period0`, `RightRPM`); left wheel uses P10.5/CCR1 (`Period2`, `LeftRPM`). The `Period2` name is inherited from the older starter code; RSLK MAX uses channel 1 for that input.
- The standard encoder produces 360 rising-edge pulses per wheel revolution. Timer_A3 counts at 12 MHz, so wheel RPM = `12000000 * 60 / (360 * period)` = `2000000 / period`. Source: [TI tachometer lecture, slide 17](https://www.ti.com/lit/ml/sekp140/sekp140.pdf).
- The first edge only establishes a timestamp. RPM is calculated from the second edge onward; a zero period returns zero instead of dividing by zero. RPM uses whole-number division.
- The current 16-bit timer wraps every 5.46 ms. A measured pulse interval must be shorter than that (wheel speed above about 31 RPM). This simple implementation retains the last RPM if pulses stop; it does not implement a stopped-wheel timeout.
- Corrected Timer_A3 priority setup to use `NVIC->IP[3]` for IRQ14/IRQ15. Removed the unused `Bump.c` link from the tachometer project to avoid its undefined `bump_data` dependency. Fixed UART output to run every 1000 foreground wake-ups instead of on 999 out of every 1000.
- To test: refresh and clean `Lab4_TimerCapture_Tach`, select Debug, support the wheels clear of the table, turn on battery power, and run without breakpoints. After the initial pause, press and release LaunchPad SW1 or SW2 once. Both wheels then run forward continuously. Watch `Done0`, `Done2`, `Period0`, `Period2`, `RightRPM`, and `LeftRPM` with Continuous Refresh. Turn off robot battery power to stop the wheels after testing.
- The tachometer program has no SW1/SW2 or bump-switch stop control. The human confirmed that turning off battery power stops the wheels. USB may stay connected. Do not rely on CCS Pause to stop hardware PWM.
- Tachometer counters, period values, and RPM values still need confirmation. Wheel motion alone does not verify speed measurement.
- Reported tachometer readings: `Period0 = 22888`, `Period2 = 24399`, `RightRPM = 87`, `LeftRPM = 84`. The right pair matches integer division (`2000000 / 22888 = 87`). The left period would give 81 RPM, so that pair needs a consistent snapshot before marking verification complete.
- Continuous Refresh can read a period and its RPM at different moments. For an arithmetic check, support the wheels clear of the table, pause the processor once, read the stable values, and turn off battery power afterward. CPU Pause alone does not stop the wheels.
- Timer capture measures actual wheel speed. The wheel encoder produces pulses; on each rising edge, timer hardware copies its current count into a capture register. Subtract two successive timestamps to get the pulse period, then convert that period to RPM.
- Know the difference: Lab 3 timer compare generates PWM to command a motor; Lab 4 timer capture measures encoder pulses to find how fast the wheel actually turns. The same PWM command does not guarantee the same RPM on both wheels.
- Know how to trace each input: right encoder P10.4 -> Timer_A3 CCR0 -> `TA3_0_IRQHandler()` -> `PeriodMeasure0()`; left encoder P10.5 -> CCR1 -> shared `TA3_N_IRQHandler()` -> `PeriodMeasure2()`.
- Know why two interrupt handlers are used: CCR0 has its own vector; the other capture/compare channels share another vector. Each handler acknowledges its interrupt and passes the captured timestamp to the matching callback.
- For RPM conversion, know the timer tick frequency and encoder pulses per wheel revolution. Here they are 12 MHz and 360 pulses/revolution. A smaller pulse period means a faster wheel. These speed readings can support speed matching, speed control, and detecting a wheel that slows under load; those controllers are not implemented in this exercise.

### Lab 5

- The assessment builds on the knowledge and practical work from Labs 1–4.

Independent readiness review, 28 October 2026 (IR accuracy excluded as requested):

| Lab | Basic code status | Evidence / remaining work |
|---|---|---|
| Lab 1 | Incomplete | `Lab1_Assembly/convert.asm` still has an empty `Convert` routine, including no return instruction. C and debugging reference programs are present. |
| Lab 2 | Complete | Reflectance driver, position calculation, and three-state FSM are implemented. Reflectance bits and FSM behavior passed physical tests. |
| Lab 3 | Code complete; mapping corrected after review | Sensors and wheel directions passed physical tests. The swapped motor duty arguments are now fixed in all four movement functions. Physical unequal-duty and bump-stop checks remain. |
| Lab 4 | Code complete, verification remains | IR conversions and RPM capture/conversion are implemented. Ignore IR accuracy for this review. The left RPM/period pair still needs a stable snapshot; latest IR firmware demonstration is not yet physically confirmed. |

- Overall: the basic demonstrations are largely prepared, but the full Lab 1–4 baseline is not yet complete. The motor duty mapping is now corrected; the Lab 1 assembly routine still needs completion.
- The published pre-known demonstrations are Lab 2 reflectance, Lab 3 bumps, and Lab 4 IR distance at 20 cm. Reflectance and all six bumps are physically confirmed. IR conversion code returns 20 for all supplied 20 cm ADC points; software agreement is not a physical accuracy check. The missing Lab 1 assembly routine does not block these three demonstrations.
- Remaining robot checks: verify bump-triggered stopping for all six switches, retest wheel behavior using unequal duties, and obtain a stable left RPM/period pair. Do the final clean builds on the lab computer, not the Mac's missing-legacy-compiler setup.
- Minor unused helper bug: `TimerA1_Stop()` disables IRQ12 (`0x1000`) instead of its CCR0 IRQ10 (`0x400`). Current lab programs do not call it, so this is not a blocker for their existing demos.
- Priority-register compatibility: the legacy source assumes word-sized `NVIC->IP` entries. The Mac's newer CCS CMSIS header uses byte-sized entries. The actual lab PC headers were not available for this audit, so priority configuration is not certified across compiler/header versions. Keep the known-working lab toolchain for assessment builds.
- Host audits checked the actual source using mock registers and supplied test data. They do not replace a CCS target build or physical timing checks. Existing user/IDE metadata and generated build changes were left untouched; no robot code was changed during this audit.
- Lab 5 is AI-OFF and web search is not allowed. Before assessment, practice editing, building, and demonstrating one single-sensor task and one combined sensor/motor task without assistance. Existing demo programs do not implement the unseen assessment tasks for you.
