/************************************************************************/
/*																																			*/
/*	led_btn_mx7.c	--	Project for Cerebot MX7														*/
/*																																			*/
/************************************************************************/
/*	Author:		Edward Nava																								*/
/*	Modified by:	Edward Nava, UNM, 20SEP18															*/
/************************************************************************/
/*  File Description:																										*/
/*		This project uses LD1, LD2 and LD3 to indicate the								*/
/*		state of BTN1, BTN2, and BTN3																			*/
/*																																			*/
/************************************************************************/
/*  Revision History:																										*/
/*																																			*/
/*	09/26/15: Modified for new function																	*/
/*																																			*/
/************************************************************************/

#include <plib.h>

/* ------------------------------------------------------------ */
/*				Configuration Bits	        */
/* ------------------------------------------------------------ */

/* Required to use the PGC1/PGD1 debugging interface on MX7 Board.		*/
/* JP-11 must be in place to use the MX7 board with MPIDE							*/

#pragma config ICESEL = ICS_PGx1

// SYSCLK = 80 MHz (8 MHz Crystal/ FPLLIDIV * FPLLMUL / FPLLODIV)
// Primary Osc w/PLL (XT+,HS+,EC+PLL)

#pragma config FPLLMUL = MUL_20, FPLLIDIV = DIV_2
#pragma config FPLLODIV = DIV_1
#pragma config POSCMOD = EC, FNOSC = PRIPLL, FPBDIV = DIV_8
#define SYS_FREQ (80000000L)



// *** these are preconfigured on the MX7 Board for a clock frequency of 80MHz
// *** and a PBCLK value of 10MHz.

/* ------------------------------------------------------------ */
/*				Forward Declarations																	*/
/* ------------------------------------------------------------ */

void DeviceInit();
void DelayInit();
void DelayMs(int cms);


/* ------------------------------------------------------------ */
/*				Definitions																						*/
/* ------------------------------------------------------------ */

#define	cntMsDelay	10000			//timer 1 delay for 1ms

/* ------------------------------------------------------------ */
/*				Main																									*/
/* ------------------------------------------------------------ */

int main()
{
	int button_in12 = 0;
	int button_in3 = 0;
	
	//Set LD1 through LD4 as digital outputs
	DeviceInit();
	
	//initialize timer for delay
	DelayInit();

	/* Perform the main application loop.
	*/
	while (1) 
	{
		// Read buttons
		button_in12 = PORTReadBits (IOPORT_G, BIT_6|BIT_7);
		button_in3 = PORTReadBits (IOPORT_A, BIT_0);
		
		if (button_in12 != 0){
			// drive both LD1 and LD2 high if both buttons pressed
			if (((button_in12 & 0x0040) != 0) && ((button_in12 & 0x0080) != 0))
				PORTWrite (IOPORT_G, BIT_12|BIT_13);
			else {
				//drive LD1 high if only BTN1 pressed
				if ((button_in12 & 0x0040) != 0) 	// BTN1 pressed?
					PORTWrite (IOPORT_G, BIT_12);
				//drive LD2 high if only BTN2 pressed
				if ((button_in12 & 0x0080) != 0)	// BTN2 pressed
					PORTWrite (IOPORT_G, BIT_13);
				}
		}
		// Handle BTN3 separately
		if(button_in3 !=0)
			PORTWrite (IOPORT_G, BIT_14);
			
		DelayMs(1);
		PORTClearBits(IOPORT_G, BIT_12|BIT_13| BIT_14|BIT_15);
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
**		Set LD1 through LD4 as digital output
/* ------------------------------------------------------------ */

void DeviceInit()
{
	// On Mx7 Board - signal conflict with BTN3 and Jtag
	// Must disable JTAG controller to use BTN3
	DDPCONbits.JTAGEN = 0;									// Disable JTAG

	//On MX7 LED1 is on RG12
	//		   LED2 is on RG13
	//		   LED3 is on RG14
	//		   LED4 is on RG15
	
	//Set ports for onboard LEDs to outputs
	PORTSetPinsDigitalOut (IOPORT_G, BIT_12|BIT_13| BIT_14|BIT_15);
	//Set ports for onboard BTNs as inputs
	PORTSetPinsDigitalIn (IOPORT_G, BIT_6 | BIT_7);
	PORTSetPinsDigitalIn (IOPORT_A, BIT_0);

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
**		initializes Timer 1 to count at 10Mhz.
/* ------------------------------------------------------------ */

void DelayInit()	
{
	unsigned int tcfg;

	// Configure Timer 1. This sets it up to count a 10Mhz with a period of 0xFFFF
	// which is the full count range of the timer
	
	tcfg = T1_ON|T1_IDLE_CON|T1_SOURCE_INT|T1_PS_1_1|T1_GATE_OFF|T1_SYNC_EXT_OFF;
	OpenTimer1(tcfg, 0xFFFF);

}

/* ------------------------------------------------------------ */
/***	DelayMs
**
**	Parameters:
**		cms			- number of milliseconds to delay
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Delay the requested number of milliseconds. Uses Timer1.
/* ------------------------------------------------------------ */

void DelayMs(int cms)
{
	int		ims;

	// Timer counts up to a value which represents 1ms and then resets to 0
	
	for (ims=0; ims<cms; ims++) {
		WriteTimer1(0);
		while (ReadTimer1() < cntMsDelay);
	}

}		