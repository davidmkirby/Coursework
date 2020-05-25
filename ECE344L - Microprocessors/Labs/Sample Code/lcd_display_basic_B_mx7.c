/*********************************************************************
 *
 *      PIC32MX SPI to LCDS Interface Example 2
 *
 *********************************************************************
 * FileName:        lcd_display_basic_B_mx7.c
 * Dependencies:    plib.h
 *
 * Processor:       PIC32MX795F512L
 *
 *
 * 
 *********************************************************************
 * The purpose of this example code is to demonstrate the PIC32MX
 * peripheral library macros and functions supporting the SPI
 * module and the use of the serial LCD display peripheral module.
 *
 * Platform: ChipKIT MX7
 *
 * Features demonstrated:
 *    - SPI peripheral serial communication to LCD display
 *    - Use of the c peripheral library functions
 *
 * Description:
 *      This program uses direct transfers to communicate through
 *      the SPI1 interface on the Chipkit MX7. With an pmod cable
 *      attatched to the MX7, the program will output commands and
 *      characters to an LCD display.
 *      
 *
 ********************************************************************/
/*  Modified: 10/31/2018 by E.J. Nava, University of New Mexico
 *  for classroom demonstration purposes.
 *  Modified to add reset function using the port D line 9 that is shared
 *  with the SPI - SS signal on JB. Requires JP1 on the CLS module to
 *  use the RST jumper.
 *
 *******************************************************************/

#include <plib.h>

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

#define PB_DIV		8			// 10 MHz peripheral clock
#define	cntMsDelay	10000		// timer 1 delay for 1ms

#define BRG 31                  // value of BRG for 156.25kHz with
                                // peripheral clock at 10Mhz

// function prototypes
void DelayInit();
void DelayMs(int cms);

int main(void)
{
    int rData;
    unsigned long int spi1mode1, spi1mode2;
    unsigned long int spi1status;  
    char * buffer = "hello world - it's a fine day";	// buffer for messages
       
    // clear the SPI SFRs before configuring for use
    SPI1CON = 0;	        // Reset SPI2 configuration register
    rData = SPI1BUF;    	// clear the receive buffer    
    SPI1BRG = BRG;          // set brg register value
    SPI1STATCLR=0X40;	    // clear the overflow
//  SPI1CON = 0x8320;	    // set the mode register - this value works

    // Configure SPI2 using the c peripheral library functions
    // This PIC only has one mode register for SPI
    
    spi1mode1 = MASTER_ENABLE_ON | SPI_SMP_ON | SPI_CKE_ON | 
                SPI_MODE8_ON;
    spi1mode2 = SPI_ENABLE;
    OpenSPI1(spi1mode1, spi1mode2);
    
	//Set port for SPI connection on pin 1 of JB
	PORTSetPinsDigitalOut (IOPORT_D, BIT_9);   

    //initialize timer for delay
    DelayInit();   
    
    //  LCD Display hardware reset
	PORTClearBits (IOPORT_D, BIT_9);
	DelayMs(100);
	PORTSetBits (IOPORT_D, BIT_9);
	DelayMs(500);
     
    // use the LCDS reset command sequence       
    SPI1BUF=0x1b;		// Display reset - first send escape char
    buffer="[*";		// command sequence for reset
    putsSPI1(2,buffer);	// write out string
    DelayMs(500);		// wait for display to reset
       
    buffer ="Hello World ! ";
    putsSPI1(strlen(buffer), buffer);
    DelayMs(1000);
    
    SPI1BUF=0x1b;		// Display Clear - first send escape char
    buffer="[j";		// command sequence for clear screen
                        // and reset cursor
    putsSPI1(2,buffer);	// write out string
    DelayMs(500);		// wait for display
     
    buffer ="This is fun!";
    putsSPI1(strlen(buffer), buffer);
    DelayMs(1000);

   while(1)
   {
        if(!TxBufFullSPI1())
        {
	    SPI1BUF=0x1b;		// Display reset - first send escape char
	    buffer="[j";		// command sequence for clear screen
                            // and reset cursor
	    putsSPI1(2,buffer);	// write out string
	    DelayMs(500);		// wait for display to reset
        }	
	buffer ="Fun!";
	putsSPI1(strlen(buffer), buffer);
    	DelayMs(1000);   
   }

    return 0;
}
// *****************************************************************************
void DelayInit()	
{
	unsigned int tcfg;

	/* Configure Timer 2. This sets it to count a 10MHz with a period of 0xFFFF */
	tcfg = T2_ON|T2_SOURCE_INT|T2_PS_1_1;
	OpenTimer2(tcfg, 0XFFFF);
	mT2ClearIntFlag();
}

void DelayMs(int cms)
{
	int		ims;
	for (ims=0; ims<cms; ims++) {
		WriteTimer2(0);
		while (ReadTimer2() < cntMsDelay);
	}
}	