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
- Reflectance bit readings have been verified on the robot. The FSM is still pending.
- Turn on the robot's battery power. USB power to the LaunchPad alone does not confirm that the sensors are powered.
- `Data` contains eight sensor bits. `1` means black and `0` means white. The leftmost bit is P7.7 and the rightmost bit is P7.0.
- Example: `00011000` means the two center sensors, P7.4 and P7.3, detect black. All white gives `0x00`; all black gives `0xFF`.
- `Position` is the average position of sensors detecting black, in 0.1 mm units. Positive is toward the robot's right; negative is left.
- In the current code, both no line (`0x00`) and a symmetric reading such as `0x18` or `0xFF` give position zero. Check `Data` to distinguish them.
- Use the Debug build configuration in CCS. Clicking the Debug button does not switch a Release build to Debug.
- Put the verification breakpoint on `Clock_Delay1ms(10);`, after `Data` and `Position` update. Keep Skip All Breakpoints off.
- Do not pause or single-step during the sensor discharge measurement. Debugger delays change the reading.
- Declaring `int i;` before `for(i = 0; ...)` avoids the loop-declaration compatibility issue encountered on the lab computer.

### Lab 3

No lessons recorded yet.

### Lab 4

No lessons recorded yet.

### Lab 5

- The assessment builds on the knowledge and practical work from Labs 1–4.
