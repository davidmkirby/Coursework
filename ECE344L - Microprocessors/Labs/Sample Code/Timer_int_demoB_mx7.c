/********************************************************************/
/*																																	*/
/*	Timer_int_demoB_mx7.c	--	Project for Cerebot MX7								*/
/*																																	*/
/********************************************************************/
/*	Author:		Edward Nava, UNM																			*/
/*	Modified by:	Edward Nava, UNM, 13Oct18													*/
/********************************************************************/
/*  File Description:																								*/
/*		This project uses LD1 and timer 2 to demonstrate							*/
/*		the use of timer interrupts - version B does 									*/
/*		enable the interrupt and includes an ISR.											*/
/*		This example uses the timer interrupt flag that								*/
/*		is set when the timer register value equals the								*/
/*		value which is stored in the period register.									*/
/*																																	*/
/********************************************************************/
/*  Revision History:																								*/
/*																																	*/
/*	10/13/18: Modified for MX7 board function												*/
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
/*				Forward Declarations																	*/
/* ------------------------------------------------------------ */

void DeviceInit();
void DelayInit();

/* ------------------------------------------------------------ */
/*				Definitions																						*/
/* ------------------------------------------------------------ */

#define PRESCALE	256						// 39,062 Hz clock to timer
#define TOGGLES_PER_SEC	2				// blink frequency
#define T2_TICK		(SYS_FREQ/PB_DIV/PRESCALE/TOGGLES_PER_SEC)
																// value for period reg

void __ISR(_TIMER_2_VECTOR, ipl2) Timer2Handler(void)
{
	// clear the interrupt flag
	mT2ClearIntFlag();
	  PORTToggleBits(IOPORT_G,BIT_12);
}

/* ------------------------------------------------------------ */
/*				Main											*/
/* ------------------------------------------------------------ */

int main()
{
	DeviceInit();   //Set LD1 as digital output
	DelayInit();	//initialize timer for delay
	int a=0;

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
**		initializes Timer 1 to count at 39,062 Hz.
/* ------------------------------------------------------------ */

void DelayInit()	
{
	unsigned int tcfg;

	/* Config Timer 2. This sets it to count 39,062 Hz with a period of T2_TICK	*/
	tcfg = T2_ON|T2_SOURCE_INT|T2_PS_1_256;
	OpenTimer2(tcfg, T2_TICK);
	
	/* Now enable system-wide multi-vector interrrupt handling	*/
	INTEnableSystemMultiVectoredInt();
	
	/* configure timer 2 interrupt with priority of 2	*/
	ConfigIntTimer2(T2_INT_ON | T2_INT_PRIOR_2);
	
	/* Clear interrupt flag	*/
	mT2ClearIntFlag();
}




		