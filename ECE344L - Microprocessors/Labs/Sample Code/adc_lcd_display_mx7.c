/*********************************************************************
 *
 *      PIC32MX ADC input with SPI to LCDS Output
 *
 *********************************************************************
 * FileName:        adc_lcd_display_mx7.c
 * Dependencies:    plib.h
 *
 * Processor:       PIC32MX795F512L
 *
 *
 * 
 *********************************************************************
 * The purpose of this example code is to demonstrate the PIC32MX
 * peripheral library macros and functions supporting the ADC module,
 * the SPI module and use of the serial LCD display peripheral module.
 *
 * Platform: ChipKIT MX4 PIC32MX
 *
 * Features demonstrated:
 *    - ADC conversion of analog input signal
 *    - SPI peripheral serial communication to LCD display
 *    - Use of the c peripheral library functions
 *
 * Description:
 *      This program uses an analog input for a source signal,
 *      which is then converted to a digital value.  The integer
 *      value is then converted to a string and transmitted to a
 *      serial LCD display via the SPI interface on the Chipkit MX7.
 *      
 *
 ********************************************************************/
/*  Modified: 11/8/2018 by E.J. Nava, University of New Mexico
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
#pragma config FSOSCEN = OFF       // Secondary oscillator enable
#define SYS_FREQ (80000000L)

#define PB_DIV		8			// 10 MHz peripheral clock
#define PRESCALE	32			// 312500 Hz clock to timer

#define	cntMsDelay	312			//timer 1 delay for 1ms

#define BRG 31                  // value of SPI BRG for 156.25kHz with
                                // peripheral clock at 10Mhz

#define POT 4			        // analog input on AN4
#define AINPUTS 0xffef		    // set all bits 1 except for AN4 line


// function prototypes
void initADC( int amask);
int readADC( int c);
void DelayInit();
void DelayMs(int cms);


int main(void)
{
    int rData;
    unsigned long int spi1mode1, spi1mode2;
    unsigned long int spi1status;
    
    char * bufferp;
    char buffer[40] = {"hello world - it's a fine day"};
    char *c_buffer = "this is a string used for commands";
    char temp;
    int i,len;
    bufferp = &buffer[0];
    
    int a;			        // integer value read from ADC
    
    char adc_str[10];		// char string for viewing ADC value
    
    //initialize timer for delay
    DelayInit();
    
    // initialize the ADC
    initADC(AINPUTS);
    
    // clear the SPI SFRs before configuring for use
    SPI1CON = 0;	    // Reset SPI1 configuration register
    rData = SPI1BUF;	// clear the receive buffer    
    SPI1BRG = BRG;       // set brg register value
    SPI1STATCLR=0X40;	// clear the overflow
//  SPI1CON = 0x8320;	// set the mode register - this value works

	//Set port for SPI connection on pin 1 of JB
	PORTSetPinsDigitalOut (IOPORT_D, BIT_9);
    
   // Configure SPI1 using the c peripheral library functions
    // This PIC only has one mode register for SPI
    
    spi1mode1 = MASTER_ENABLE_ON | SPI_SMP_ON | SPI_CKE_ON | 
                SPI_MODE8_ON;
    spi1mode2 = SPI_ENABLE;
    OpenSPI1(spi1mode1, spi1mode2);   
    
    //  LCD Display hardware reset
	PORTClearBits (IOPORT_D, BIT_9);
	DelayMs(100);
	PORTSetBits (IOPORT_D, BIT_9);
	DelayMs(500);
    
    SPI1BUF=0x1b;		    // Display reset - first send escape char
    c_buffer = "[*";		// command sequence for reset
    putsSPI1(2,c_buffer);	// write out string
    DelayMs(500);		    // wait for display to reset
       
    bufferp ="Hello World ";
    putsSPI1(strlen(bufferp), bufferp);
    DelayMs(1000);
    
    SPI1BUF=0x1b;		    // Cursor reset - first send escape char
    c_buffer="[j";		    // command sequence for clear screen
                            // and reset cursor
    putsSPI1(2,c_buffer);	// write command string to display
    DelayMs(1000);		    // wait for display to reset
     
    bufferp ="This is fun!";
    putsSPI1(strlen(bufferp), bufferp);
    DelayMs(500);
    
    SPI1BUF=0x1b;		    // Cursor reset - first send escape char
    c_buffer="[j";		    // command sequence for clear screen
                            // and reset cursor
    putsSPI1(2,c_buffer);	// write out string
    DelayMs(1000);		    // wait for display to reset
	    
    while (1) {
                        // read data from ADC and convert to string
	a = readADC(POT);		    // selecct POT input as integer   
	sprintf(adc_str,"%d",a );	// convert int to ASCII string

    SPI1BUF=0x1b;		    // cursor reset - first send escape char
	c_buffer="[j";  		// command sequence for clear screen
                			// and reset cursor
	putsSPI1(2,c_buffer);	// write out string

	DelayMs(1000);		    // wait for display to reset
	putsSPI1(strlen(adc_str),adc_str);	// write out string
	DelayMs(1000);		    // wait for display to reset
    
    }
    return 0;
}
// *****************************************************************************
void DelayInit()	
{
	unsigned int tcfg;

	/* Configure Timer 2. This sets it to count a 312500 Hz with a period of T2_TICK */
    
	tcfg = T2_ON|T2_SOURCE_INT|T2_PS_1_32;
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

void initADC( int amask)
{
    AD1PCFG = amask;		// select analog input pins
    AD1CON1 = 0x00E0;		// automatic conversion after sampling
    AD1CSSL = 0;		    // no scanning required
    AD1CON2 = 0;		    // use MUXA, AVss & AVdd used as vref +/-
    AD1CON3 = 0X1F01;		// Tad=2*(1+1)*Tpb=4*100ns>Tpb(min)=135ns
    AD1CON1bits.ADON = 1;	// turn on the ADC
}

int readADC( int ch)
{
    AD1CHSbits.CH0SA = ch;	    // 1. select analog input
    AD1CON1bits.SAMP = 1;	    // 2. start sampling
    while (!AD1CON1bits.DONE);	// 3. wait for conversion completion
    return ADC1BUF0;		    // 4. read the conversion result	
}

