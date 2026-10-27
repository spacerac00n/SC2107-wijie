// Bump.c
// Runs on MSP432
// Provide low-level functions that interface bump switches the robot.
// Daniel Valvano and Jonathan Valvano
// July 2, 2017

/* This example accompanies the books
   "Embedded Systems: Introduction to the MSP432 Microcontroller",
       ISBN: 978-1512185676, Jonathan Valvano, copyright (c) 2017
   "Embedded Systems: Real-Time Interfacing to the MSP432 Microcontroller",
       ISBN: 978-1514676585, Jonathan Valvano, copyright (c) 2017
   "Embedded Systems: Real-Time Operating Systems for ARM Cortex-M Microcontrollers",
       ISBN: 978-1466468863, , Jonathan Valvano, copyright (c) 2017
 For more information about my classes, my research, and my books, see
 http://users.ece.utexas.edu/~valvano/

Simplified BSD License (FreeBSD License)
Copyright (c) 2017, Jonathan Valvano, All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are
those of the authors and should not be interpreted as representing official
policies, either expressed or implied, of the FreeBSD Project.
*/

#include <stdint.h>
#include "msp.h"

void Bump_Init(void){
    // write this as part of Lab 3
    // Configure P4.0, P4.2, P4.3, P4.5, P4.6, P4.7 as inputs with pull-up resistors
    P4->SEL0 &= ~0xED;
    P4->SEL1 &= ~0xED;
    P4->DIR &= ~0xED;
    P4->REN |= 0xED;
    P4->OUT |= 0xED;
    
    // Interrupt Configuration for Port 4
    P4->IES |= 0xED;                     // P4.0, P4.2, P4.3, P4.5, P4.6, P4.7 are falling edge event
    P4->IFG &= ~0xED;                    // clear flags
    P4->IE |= 0xED;                      // arm interrupt on P4.0, P4.2, P4.3, P4.5, P4.6, P4.7
    
    // Port 4 interrupt has index 38. IP[9] handles 36-39. Byte 2 is for 38.
    NVIC->IP[9] = (NVIC->IP[9]&0xFF00FFFF)|0x00400000; // priority 2
    // ISER[1] handles 32-63. Bit 6 (38-32) is for 38.
    NVIC->ISER[1] = 0x00000040;          // enable interrupt 38 in NVIC
}

uint8_t Bump_Read(void){
    uint8_t result;

    // write this as part of Lab 3
    uint8_t in = P4->IN;
    // Pack 6 bump switch states into lower 6 bits (P4.0->b0, P4.2->b1, P4.3->b2, P4.5->b3, P4.6->b4, P4.7->b5)
    result = (in & 0x01) | ((in & 0x0C) >> 1) | ((in & 0xE0) >> 2);

    return (result);
}

// Global variable to store bump data updated by ISR
extern volatile uint8_t bump_data;

void PORT4_IRQHandler(void){
    // Read the switches
    bump_data = Bump_Read();
    // CRUCIAL: Clear the interrupt flags for the bump switches to prevent infinite loop
    P4->IFG &= ~0xED;
}
