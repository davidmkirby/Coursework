/*********************************************************************
 *
 *      PIC32MX PWM Output Demo
 *
 *********************************************************************
 * FileName:        pwm_sound_demo_MX7.c
 * Dependencies:    plib.h
 *
 * Processor:       PIC32MX795F512L
 *
 *
 * 
 *********************************************************************
 * The purpose of this example code is to demonstrate the PIC32MX
 * peripheral library macros and functions supporting the PWM and output
 * compare module.
 *
 * Platform: ChipKIT MX7
 *
 * Features demonstrated:
 *    - output compare function
 *    - PWM operation
 *    - Use of the c peripheral library functions
 *
 * Description:
 *      This program uses a varying square wave output to drive
 *      an analog speaker / buzzer.
 *
 ********************************************************************/
/*  Modified: 11/21/2018 by E.J. Nava, University of New Mexico
 *  for classroom demonstration purposes.
 *
 *******************************************************************/

#include <plib.h>
#include <stdio.h>

// Configure MX7 board for debugging
#pragma config ICESEL = ICS_PGx1

#pragma config FNOSC = PRIPLL		// Configure the system clock
#pragma config POSCMOD = EC
#pragma config FPLLIDIV = DIV_2
#pragma config FPLLMUL = MUL_20
#pragma config FPLLODIV = DIV_1
#pragma config FPBDIV = DIV_8
#pragma config FSOSCEN = OFF            // Secondary oscillator enable
#define SYS_FREQ (80000000L)

#define	cntMsDelay	312			//timer 4 delay for 1ms

/*
#define POT 4			    // analog input on AN4
#define AINPUTS 0xffEf		// set all bits 1 except for AN4 line
#define ADC_COUNT 1023		// number of values represented by ADC
#define VMAX 3.2		    // Vref +
#define VMIN 0.0		    // Vref -
*/

// function prototypes
void DelayInit();
void DelayMs(int cms);
void Sound(int frequency, int duration);


int main(void)
{
    
    //initialize timer for delay
    DelayInit();

    while (1) {    
        Sound(262,2000);
        Sound(294,2000);
        Sound(330,2000);
        Sound(349,2000);
        Sound(392,2000);
        Sound(440,2000);
        Sound(494,2000);
        Sound(523,2000);
    }



   return 0;
}
// *****************************************************************************


void DelayInit()	
{
	unsigned int tcfg4;

	/* Configure Timer 4. This sets clock to 312500 Hz */
	tcfg4 = T4_ON|T4_SOURCE_INT|T4_PS_1_32;
	OpenTimer4(tcfg4, 0XFFFF);
	mT4ClearIntFlag();

}

void DelayMs(int cms)
{
	int ims;
	for (ims=0; ims<cms; ims++) {
		WriteTimer4(0);
		while (ReadTimer4() < cntMsDelay);
	}

}

void Sound(int frequency, int duration)
{
    unsigned int tcfg;
    unsigned int period;
    unsigned int timer_clk = 5000000L;
    period = (unsigned int)(timer_clk /frequency);
    
    // Configure 32 bit Timer 23. This sets clock to 5MHz
    
    tcfg = T2_ON|T2_SOURCE_INT|T2_32BIT_MODE_ON|T2_PS_1_2;
    OpenTimer23(tcfg, period);      // period set fundamental freq
    
    // configure OC1 using timer 2 in 32 bit mode
    
    OpenOC2(OC_ON|OC_TIMER_MODE32|OC_TIMER2_SRC|
            OC_PWM_FAULT_PIN_DISABLE,period,period);

    SetDCOC2PWM(period/2);          // set duty cycle to 50%
    DelayMs(duration);
    CloseOC2();                     // turn off oscillation
    
}
