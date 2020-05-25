/*********************************************************************
 *
 *      PIC32MX UART Interface Example
 *
 *********************************************************************
 * FileName:        uart_basic_tr_intr_mx7.c
 * Dependencies:    plib.h
 *
 * Processor:       PIC32MX795F512L
 *
 *
 * 
 *********************************************************************
 * The purpose of this example code is to demonstrate the PIC32MX
 * peripheral library macros and functions supporting the UART
 * module and its various features.
 *
 * Platform: ChipKIT MX7 PIC32MX
 *
 * Features demonstrated:
 *    - UART perepheral library usage
 *
 * Description:
 *      This program uses the UART library to communicate through
 *      the serial port on the Chipkit MX4. With an RS232 cable
 *      attatched to the MX4 and a pc, the program will
 *      output text and recieve input using a terminal program.
 *      This version is modified to use a receive interrupt to signal
 *      that a character is available for use.
 *      
 ********************************************************************/
/*  Modified: 10/19/2018 by E.J. Nava, University of New Mexico
 *  for classroom demonstration purposes.
 *
 *******************************************************************/

#include <plib.h>

// Configure MX7 board for debugging
#pragma config ICESEL = ICS_PGx1

#pragma config FNOSC = PRIPLL
#pragma config POSCMOD = EC
#pragma config FPLLIDIV = DIV_2
#pragma config FPLLMUL = MUL_20
#pragma config FPLLODIV = DIV_1
#pragma config FPBDIV = DIV_8
#pragma config FSOSCEN = OFF            // Secondary oscillator enable
#define SYS_FREQ (80000000L)

#define PB_DIV		8			// 10 MHz peripheral clock
#define PRESCALE	256			// 312500 Hz clock to timer
#define TOGGLES_PER_SEC	2			// blink frequency
#define T2_TICK		(SYS_FREQ/PB_DIV/PRESCALE/TOGGLES_PER_SEC)
						// value for period reg
#define	cntMsDelay	10000			//timer 1 delay for 1ms


// prototypes

void DeviceInit();
void DelayInit();
void DelayMs(int cms);

// Global Variables

int count = 0;
unsigned int c;

// Interrupt Service Routines

void __ISR(_TIMER_2_VECTOR, ipl2) Timer2Handler(void)
{
	// clear the interrupt flag
	mT2ClearIntFlag();
	  PORTToggleBits(IOPORT_G,BIT_12);
}

void __ISR(_UART2_VECTOR, ipl3) Uart2Handler(void)
{
	extern unsigned int c;
	extern int count;

		c = ReadUART2();				// read char from RXREG
		mU2RXClearIntFlag();		// clear int flag
		count++;								// increment char counter
     
        // echo the character
  	WriteUART2(c);    
}


int main(void)
{
    unsigned long int u2mode;
    unsigned long int u2status;
    
   //Set LD1 as digital output
    DeviceInit();
    //initialize timer for delay
    DelayInit();
 
	// UART Configuration values
	
    u2mode = UART_EN | UART_IDLE_CON | UART_RX_TX |
                UART_DIS_WAKE | UART_DIS_LOOPBACK |
                UART_DIS_ABAUD | UART_NO_PAR_8BIT | UART_EN_BCLK |
                UART_1STOPBIT | UART_IRDA_DIS | UART_MODE_SIMPLEX |
                UART_NORMAL_RX | UART_BRGH_SIXTEEN;
    u2status = UART_TX_PIN_LOW | UART_RX_ENABLE | UART_TX_ENABLE|UART_INT_RX_CHAR;
    
//    u2mode = 0xb800;          // equivalent instructions
//    u2status = 0x1400;      
    
    OpenUART2(u2mode, u2status, 259);
    ConfigIntUART2(UART_RX_INT_EN|UART_TX_INT_DIS|UART_INT_PR3);
    // clear the interrupt flag
		mU2RXClearIntFlag();
        
    WriteUART2(62 );        // prompt
   
  /* Perform the main application loop. 	*/
	
	while (1) 
	{
		Nop();
		
	}

    return 0;
}
// *****************************************************************************




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
	PORTClearBits(IOPORT_G,BIT_12);	//On MX7 LED1 is on RG

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

	/* Config Timer 2. This sets it to count 312500 Hz with a period of T2_TICK	*/
	tcfg = T2_ON|T2_SOURCE_INT|T2_PS_1_256;
	OpenTimer2(tcfg, T2_TICK);
	
	/* Now enable system-wide multi-vector interrrupt handling	*/
	INTEnableSystemMultiVectoredInt();
	
	/* configure timer 2 interrupt with priority of 2	*/
	ConfigIntTimer2(T2_INT_ON | T2_INT_PRIOR_2);
	
	/* Clear interrupt flag	*/
	mT2ClearIntFlag();

}

