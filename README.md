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
