# SC2107-wijie — Cloud environment available

- Agent-assisted preparation for SC2107 Lab 5 on the TI RSLK MAX; Labs 1-4 supply the drivers and reference code.

## Agent starting points

- **Use [ModularFunctions](labs/lab5-assessment/ModularFunctions/README.md) first when building Lab 5 programs, where its functions fit the task.** Copy/adapt the required helpers before writing new implementations. Check task restrictions before reusing any helper.
- Read the actual question, [Lab 5 briefing](labs/Lab5-Assessment%20-%202026S1.pdf), [manual](labs/SC2107-Lab5-Manual-2026S1-v7.4M.pdf), and [code index](labs/lab5-assessment/README.md). Detailed APIs, dependencies, pins, and tests live in the index/library README.
- Make only necessary changes; preserve unrelated files and CCS settings. Keep motion/LED updates nonblocking where needed. Explain changes and robot checks briefly; assume fundamentals are known.
- Distinguish host checks, successful CCS builds, and physical verification. Add only useful, concise learning pointers here; keep detailed procedures in local references.

## Lab 5 assessment

- Pre-known demos: all eight reflectance bits, all six bump switches, and all three IR distances. IR tolerance is +/-5 cm; manual specifies 20 cm, briefing 20-30 cm. Follow the assigned criteria.
- Options: two L tasks, L+M, or L+H. L uses one learned function; M combines functions; H adds an algorithm/design. Example tasks are not the released question list.
- Sample H converter requires GPIO bump interrupts and forbids conversion libraries. Sample M description/assessment conflict; resolve actual criteria before implementing.
- Deadlines: pre-known within 1 hour; remaining tasks within 2 hours. Have each completed task validated separately. Upload `Fullname.zip` to NTULearn and hand in the assessment sheet before leaving.
- Locally stored snippets/NTULearn references are allowed; web search and GenAI are prohibited during the practical. This repository supports preparation.

## Standalone task folders

- Create independent `L-task`, `M-task`, or other requested question folders. Each contains its own main, selected helpers, required driver sources/headers, startup/system/linker files, and CCS project/target settings.
- Copy dependencies inside each task folder. All source links/include paths must resolve there; no dependencies on root `inc/`, another lab/task, or `lab5-assessment`.
- Verify a relocated task folder outside SC2107 builds independently. Submit task folders; `ModularFunctions` is the agent's preparation reference.

## Build and transfer

- Mac: edit/check code. Lab PC: build, flash, debug robot using **Debug configuration and legacy TI ARM-CGT 16.9.x.LTS**. The Mac lacks legacy `armcl`; preserve the lab toolchain.
- Git transfers tracked files. **`labs/` is ignored**, including manuals, index, and ModularFunctions; copy separately by ZIP/thumb drive. Extract to local disk before importing; do not build inside ZIP/on USB.
- Build successfully before Debug/loading `.out`; reload after edits. Use one main and one handler per interrupt. Never transfer generated Debug/Release files as build inputs.
- Battery power is required for sensor/motor checks. Raise wheels for first motion tests; CPU Pause may leave PWM running. Turn battery power off if wheel drive must stop while debugging.
- UART: current robot's **XDS110 Application/User UART** COM port, 115200 baud, 8N1, no flow control. Recheck COM number after switching robots.

## Learning

### Lab 1

- GPIO masking, shifts, and volatile examples: [main.c](Lab1_C_Programming/main.c). CCS/startup/linker reference: [code index](labs/lab5-assessment/README.md).
- Keep interrupt-shared/debugger-observed data volatile. Legacy loop compatibility: declare the index before `for(i=...)`.

### Lab 2

- [Reflectance driver](inc/Reflectance.c): black=1; P7.0/S1=rightmost, P7.7/S8=leftmost. Any selected black: `(data & mask) != 0`. All white=`0x00`; center pair=`0x18`.
- Read with 1000 us discharge as the starting setting; do not pause/single-step inside the measurement. `Position=0` can mean centered OR no line: check raw bits.
- [FSM](Lab2_FSM/Lab2_FSMmain-3states.c): input `(data >> 3) & 3`; `11`=straight/yellow, `01`=steer right/green, `10`=steer left/red. `00` keeps search history.
- Left of line -> steer right -> left wheel forward/faster. Reflectance bits and FSM colors were physically verified in their lab demos.

### Lab 3

- [Bump driver](inc/Bump.c): raw 0=pressed; none=`0x3F`. Packed bump0..5 map to P4.0/.2/.3/.5/.6/.7. Normalized pressed=1: `(~Bump_Read()) & 0x3F`; prefer `Lab5Bump_Pressed()`.
- GPIO ISR owns a raw last-press `bump_data` snapshot; release does not refresh it. Define `volatile uint8_t bump_data = 0;` exactly once when linking Bump.c; the modular wrapper already defines it.
- [Motor driver](inc/Motor.c): arguments are left/right duty, 0-7499. Correct mapping: right=P2.6/CCR3, left=P2.7/CCR4. `Motor_Left/Right()` pivot; they do not measure a requested angle.
- Individual bumps and wheel directions passed lab-demo checks. Unequal-duty mapping and bump-stop behavior still need physical verification.

### Lab 4

- [IR conversions](inc/IRDistance.c): distances are cm; `nl/nc/nr` are raw left/center/right ADC counts. UART prints left, center, right. [Calibration data](labs/lab5-assessment/IR-calibration.md) is robot-specific; center near branch is ambiguous.
- At an actual 20 cm, accept 15-25 cm for each sensor. Human reported accurate-looking output; exact all-sensor readings remain unrecorded.
- [Encoder capture](inc/TA3InputCapture.c): right=P10.4/CCR0, left=P10.5/CCR1; reuse existing handlers through callbacks. Nominal 360 rising edges/revolution; period-based RPM=`2000000 / period` at 12 MHz.
- Watch `RightRPM/LeftRPM`, not motor function names. Period-based RPM aliases below about 31 RPM and stays stale after stopping. For degree turns, use modular cumulative counts and measured wheel/track geometry; dimensions are currently unset. Library host checks passed; its legacy CCS build and robot calibration/tests remain pending.
