// IRDistance.c
// Runs on MSP432
// Provide mid-level functions that convert raw ADC
// values from the GP2Y0A21YK0F infrared distance sensors to
// distances in cm.
// Jonathan Valvano
// May 25, 2017

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

// Pololu #3543 Vreg (5V regulator output) connected to all three Pololu #136 GP2Y0A21YK0F Vcc's (+5V) and MSP432 +5V (J3.21)
// Pololu #3543 Vreg (5V regulator output) connected to positive side of three 10 uF capacitors physically near the sensors
// Pololu ground connected to all three Pololu #136 GP2Y0A21YK0F grounds and MSP432 ground (J3.22)
// Pololu ground connected to negative side of all three 10 uF capacitors
// MSP432 P9.0 (J5) (analog input to MSP432) connected to right GP2Y0A21YK0F Vout
// MSP432 P4.1 (J1.5) (analog input to MSP432) connected to center GP2Y0A21YK0F Vout
// MSP432 P9.1 (J5) (analog input to MSP432) connected to left GP2Y0A21YK0F Vout

#include <stdint.h>
#include "msp.h"
#include "../inc/ADC14.h"

/*
 * Routine to convert Filtered Raw ADC values to distance data.
 * Either via curve fitting (hyperbolic, polynomial, log etc), or piece-wise linear method.
 */
int32_t LeftConvert(int32_t nl){        // returns left distance in cm
    // 5, 10, ..., 50 cm. Only 5, 10 and 30 cm were measured; others estimated.
    static const int32_t adc[10] = {
        14780, 13740, 9060, 6326, 4590, 3742, 2934, 2393, 2144, 1912
    };
    int32_t i, span;

    if(nl >= adc[0]) return 5;
    for(i = 0; i < 9; i++){
        if(nl >= adc[i+1]){
            span = adc[i] - adc[i+1];
            return 5 + 5*i + (5*(adc[i] - nl) + span/2)/span;
        }
    }
    return 50;
}

int32_t CenterConvert(int32_t nc){   // returns center distance in cm
    // 10, 15, ..., 50 cm. Exclude the ambiguous 5 cm reading (13515).
    static const int32_t adc[9] = {
        15728, 10582, 7575, 5666, 4734, 3845, 3251, 2977, 2722
    };
    int32_t i, span;

    if(nc >= adc[0]) return 10;
    for(i = 0; i < 8; i++){
        if(nc >= adc[i+1]){
            span = adc[i] - adc[i+1];
            return 10 + 5*i + (5*(adc[i] - nc) + span/2)/span;
        }
    }
    return 50;
}

int32_t RightConvert(int32_t nr){      // returns right distance in cm
    // 5, 10, ..., 50 cm. Only 5, 10 and 30 cm were measured; others estimated.
    static const int32_t adc[10] = {
        14000, 13427, 9106, 6581, 4978, 4195, 3448, 2950, 2720, 2505
    };
    int32_t i, span;

    if(nr >= adc[0]) return 5;
    for(i = 0; i < 9; i++){
        if(nr >= adc[i+1]){
            span = adc[i] - adc[i+1];
            return 5 + 5*i + (5*(adc[i] - nr) + span/2)/span;
        }
    }
    return 50;
}
