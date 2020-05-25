/*********************************************************************
 *
 *      PIC32MX I2C to TMP3 Interface Example 2
 *
 *********************************************************************
 * FileName:        temp_lcd_display_basic_2_mx7.c
 * Dependencies:    plib.h
 *
 * Processor:       PIC32MX795F512L
 *
 *
 * 
 *********************************************************************
 * The purpose of this example code is to demonstrate the PIC32MX
 * peripheral library macros and functions supporting the I2C interface
 * with the TMP3 module as well as the SPI interface and 
 * the serial LCD display peripheral module.
 *
 * Platform: ChipKIT MX7
 *
 * Features demonstrated:
 *    - SPI peripheral serial communication to LCD display
 *    - I2C peripheral serial communication to TMP3 module
 *    - Use of the TMP3 module for measuring temperature
 *    - Use of the c peripheral library functions
 *
 * Description:
 *      This program uses direct transfers to communicate through
 *      the SPI and I2C interfaces on the Chipkit MX7. With an pmod cables
 *      attatched to the MX7, the program will output 
 *      characters and temperatures on the LCD display.
 *      
 *
 ********************************************************************/
/*  Modified: 11/5/2018 by E.J. Nava, University of New Mexico
 *  for classroom demonstration purposes.
 *
 *******************************************************************/

#include <plib.h>
#include <math.h>

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
#define I2C_CLOCK_FREQ 100000	// 100KHz I2C clock

#define	cntMsDelay	10000		//timer 1 delay for 1ms

#define SPIBRG 31               // value of SPI BRG for 156.25kHz with
                                // peripheral clock at 10Mhz

#define I2CBRG 0x009		    // baud rate for 10Mhz clock to I2C
                                // for 100Khz fsck

// prototypes

void DelayInit();
void DelayMs(int cms);

// global variables
    unsigned char i2c_data[4];		// buffer for TMP3 data
    unsigned char SlaveAddress;		// I2C slave device TMP3 address
    
 	short int a, b, rd_cnt;

    unsigned char *in_char_p; 
    int raw_temp, c;				// raw temp data in int form
	int Success;



int main(void)
{

	int Index;
	int DataSz;

    int rData;
    unsigned long int spi1mode1, spi1mode2;
    unsigned long int spi1status;
    
   char str[10];		// char string for viewing value
   char buffer[40] = {"hello world - it's a fine day"};
    
    char * bufferp;
    char *c_buffer = "this is a string used for commands";

    bufferp = &buffer[0];
  	
    a = 0;
    b = 0;
	c = 0;    
    in_char_p = &i2c_data[0];			// set pointer to start of array

       
    // clear the SPI SFRs before configuring for use
    SPI1CON = 0;	    // Reset SPI2 configuration register
    rData = SPI1BUF;	// clear the receive buffer    
    SPI1BRG = SPIBRG;   // set brg register value
    SPI1STATCLR=0X40;	// clear the overflow
    SPI1CON = 0x8320;	// set the mode register - this value works
    
    //Set ports for SS connection on pin 1 of JD
	PORTSetPinsDigitalOut (IOPORT_D, BIT_9);

    //initialize timer for delay
    DelayInit();
    
    /* ----- reset LCD Display using a port output -----   */
    PORTClearBits (IOPORT_D, BIT_9);
	DelayMs(100);
	PORTSetBits (IOPORT_D, BIT_9);
	DelayMs(100);

   /* --- LCD Display Startup ---  */ 
    SPI1BUF=0x1b;		    // Display reset - first send escape char
    c_buffer = "[*";		// command sequence for reset
    putsSPI1(2,c_buffer);	// write out string
    DelayMs(500);		    // wait for display to reset
       
    bufferp ="Hello World ";    // A message to show the system is operating
    putsSPI1(strlen(bufferp), bufferp);
    DelayMs(500);
  
    /* ---- configure and initialize the I2C interface ---- */
    /* ---- initialize tmp3 module to read 9 bit temp ----- */
    
	OpenI2C1(I2C_EN, I2CBRG);	// configure I2C module 2
    
	SlaveAddress = 0x4f;	// slave address of TMP3 pmod set with
							// jumpers JP3,JP2,JP1 

	i2c_data[0] = (SlaveAddress << 1) | 0x0;	// address with write bit set
	i2c_data[1] = 0x00;		// select register 0 on tmp3 module
	DataSz = 2;				// transmit two bytes for register config
	
	StartI2C1();		// send the start bit
	IdleI2C1();			// wait to complete
 
    Index = 0;          // transmit bytes to tmp3 module
	while( DataSz )
    {
		MasterWriteI2C1 (i2c_data[Index++]);
		IdleI2C1();		// wait to complete
		DataSz--;
		
		if(I2C1STATbits.ACKSTAT)		//ACKSTAT is 0 on slave ack
			break;
    }

	StopI2C1();				// Stop I2C bus
    IdleI2C1();				// wait to complete
    
    while (1) {
        
        /* ------ Write to tmp3 to set register complete - now read temp data ------	*/
	
        RestartI2C1();			// Send the stop condition
        IdleI2C1();				// Wait to complete
	
        MasterWriteI2C1 ((SlaveAddress << 1) | 0x01);	// transmit a read command
        IdleI2C1();				// Wait to complete

        rd_cnt = MastergetsI2C1( 2, in_char_p, 152);	// read two bytes

        StopI2C1();				// Stop I2C bus
        IdleI2C1();				// wait to complete

        a = (short int) i2c_data[0];	// cast bytes to 16 bits
        b = (short int) i2c_data[1];
        raw_temp = b | (a << 8);		// combine bytes to 9 bit result
        c = raw_temp /256;				// shift out ls 7 bits of 0 - degrees C
        c = ((c * 9)/ 5) + 32;			// Convert to Farenheit
        

        sprintf(str,"%d",c );	// convert int to ASCII string

        SPI1BUF=0x1b;		    // cursor reset - first send escape char
        c_buffer="[j";  		// command sequence for clear screen
								// and reset cursor
        putsSPI1(2,c_buffer);	// write out string

        DelayMs(10);		    // wait for display to reset
        putsSPI1(strlen(str),str);	// write out string
        DelayMs(100);		    // wait for display to reset  
    }

    return 0;
}
// *****************************************************************************
void DelayInit()	
{
	unsigned int tcfg;

	/* Configure Timer 2. This sets it to count a 10 MHz    */
    /*  with a period of .1 microsecond                     */
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