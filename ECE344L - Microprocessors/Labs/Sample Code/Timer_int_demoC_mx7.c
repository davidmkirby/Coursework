/********************************************************************/
/*																																	*/
/*	Timer_int_demoC_mx7.c	--	Project for Cerebot MX7								*/
/*																																	*/
/********************************************************************/
/*	Author:		Edward Nava																						*/
/*	Modified by:	Edward Nava, UNM, 16OCT18													*/
/********************************************************************/
/*  File Description:																								*/
/*		This project uses LD1 and timers 2 & 3 to demonstrate					*/
/*		the use of 32 bit timer interrupts - This version							*/
/*		enables the interrupt and includes the ISR.										*/
/*		This example does use the time interrupt flag that						*/
/*		is set when the timer register value equals the								*/
/*		value which is stored in the period register.									*/
/*																																	*/
/********************************************************************/
/*  Revision History:																								*/
/*																																	*/
/*	10/16/18: Modified for 32 bit timer function										*/
/*																																	*/
/********************************************************************/

#include <peripheral/system.h>
#include <plib.h>

// Configure MX7 board for debugging
#pragma config ICESEL = ICS_PGx1

// SYSCLK = 80 MHz (8 MHz Crystal/ FPLLIDIV * FPLLMUL / FPLLODIV)
// Primary Osc w/PLL (XT+,HS+,EC+PLL)
#pragma config FNOSC = PRIPLL
#pragma config POSCMOD = EC
#pragma config FPLLIDIV = DIV_2
#pragma config FPLLMUL = MUL_20
#pragma config FPLLODIV = DIV_1
#pragma config FPBDIV = DIV_8
#pragma config FSOSCEN = OFF            // Secondary oscillator enable
#define SYS_FREQ (80000000L)
#define PB_DIV 8


/* ------------------------------------------------------------ */
/*				Forward Declarations							*/
/* ------------------------------------------------------------ */

void DeviceInit();
void DelayInit();

/* ------------------------------------------------------------ */
/*				Definitions										*/
/* ------------------------------------------------------------ */

#define PRESCALE	256				// 312500 Hz clock to timer
#define SECONDS_PER_TOGGLE	5		// blink interval - seconds
#define T23_TICK		((SYS_FREQ/PB_DIV/PRESCALE)*SECONDS_PER_TOGGLE)
									// value for period reg


void __ISR(_TIMER_23_VECTOR, ipl2) Timer23Handler(void)
{
	// clear the interrupt flag
	mT3ClearIntFlag();
	  PORTToggleBits(IOPORT_G,BIT_12);
}

/* ------------------------------------------------------------ */
/*				Main											*/
/* ------------------------------------------------------------ */

int main()
{
	
    //Set LD1 as digital output
	DeviceInit();
	//initialize timer for delay
	DelayInit();

	/* Perform the main application loop. 	*/
	
	while (1) 
	{
		Nop();
		
 	}
}

/* ------------------------------------------------------------ */
/*  DeviceInit()
**
**	Parameters:
**		none
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Set LD1 as digital output
/* ------------------------------------------------------------ */

void DeviceInit()
{
	//On MX7 LED1 is on RG12
	//		   LED2 is on RG13
	//		   LED3 is on RG14
	//		   LED4 is on RG15
	//Set ports for onboard LEDs to outputs & claer them
	PORTSetPinsDigitalOut (IOPORT_G, BIT_12);
	PORTClearBits(IOPORT_G,BIT_12);
}

/* ------------------------------------------------------------ */
/***	DelayInit
**
**	Parameters:
**		none
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initialized the hardware for use by delay functions. This
**		initializes Timer 1 to count at 312500 Hz.
/* ------------------------------------------------------------ */

void DelayInit()	
{
	unsigned int tcfg;

	/* Config Timer 2-3. This sets it to count 312500 Hz with a period of T2_TICK	*/
	/* Timer 2 forms the least significant word and timer 3 is the most significant	*/
	/* For 32 bit operation, use SFR of first timer for control	and use second		*/
	/* timer for interrupt operations.												*/
	
	tcfg = T2_ON|T2_SOURCE_INT|T2_PS_1_256;
	OpenTimer23(tcfg, T23_TICK);
	
	/* Now enable system-wide multi-vector interrrupt handling	*/
	INTEnableSystemMultiVectoredInt();
	
	/* configure timer 2 interrupt with priority of 2	*/
	ConfigIntTimer23(T23_INT_ON | T23_INT_PRIOR_2);
	
	/* Clear interrupt flag	*/
	mT3ClearIntFlag();

}




		