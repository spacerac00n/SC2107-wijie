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
- The existing code already implements SysTick reflectance sampling, GPIO bump interrupts, and motor/PWM integration. Verify the existing code before making changes. Reflectance and all six bump sensor tests have passed on the robot. Motor/PWM verification is pending.
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

### Lab 4

No lessons recorded yet.

### Lab 5

- The assessment builds on the knowledge and practical work from Labs 1–4.
