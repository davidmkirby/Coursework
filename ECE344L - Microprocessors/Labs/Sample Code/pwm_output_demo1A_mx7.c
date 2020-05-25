/*********************************************************************
 *
 *      PIC32MX PWM Output Demo
 *
 *********************************************************************
 * FileName:        pwm_output_demo1A_mx7.c
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
 *    - Analog input using ADC
 *    - Use of the c peripheral library functions
 *
 * Description:
 *      This program allows a user to vary the duty cycle of a square
 *      wave output to vary the intensity of an LED.  The illumination
 *      level is controlled by a potentiometer connected to AN4,
 *      converted by the ADC to a duty cycle value, which is then
 *      written to the OC2 SFR.
 *
 *      The program uses timer 2 for the output compare function and
 *      timer 4 to implement a delay function.
 *
 ********************************************************************/
/*  Modified: 11/21/2108 by E.J. Nava, University of New Mexico
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

#define	cntMsDelay	312		//timer 4 delay for 1ms

#define POT 4			    // analog input on AN4
#define AINPUTS 0xffef	    // set all bits 1 except for AN4 line
#define ADC_COUNT 1023	    // number of values represented by ADC
#define VMAX 3.2		    // Vref +
#define VMIN 0.0		    // Vref -


// function prototypes
void initADC( int amask);
int readADC( int c);
void DelayInit();
void DelayMs(int cms);


int main(void)
{
    unsigned int tcfg;          // timer configuration word
    unsigned int adc_value;     // adc input value 0..0x400

    
    //initialize timer for delay
    DelayInit();

    // Configure Timer 2. This sets clock to 39.06 KHz
    // Input clock Period is 25.6 uSec
    // Timer cycles in 26.2 mSec
    
    tcfg = T2_ON|T2_SOURCE_INT|T2_PS_1_256;
    OpenTimer2(tcfg, 0X400);       // 1024 Max ADC count
        
    // configure OC1 using timer 2 in 16 bit mode
    
    OpenOC2(OC_ON|OC_TIMER_MODE16|OC_TIMER2_SRC|
            OC_PWM_FAULT_PIN_DISABLE,0X400,0X400);
    
    SetDCOC2PWM(0x200);          // set duty cycle to 50%

   // initialize the ADC   
    initADC(AINPUTS);		    // initialize the ADC
    
    // sample and OC1 duty cycle control loop
    
    while (1) {
       	// read data from ADC
	adc_value = readADC(POT);   // select POT input as integer   
        SetDCOC2PWM(adc_value );     // set duty cycle as set by potentiometer
        DelayMs(10); 
    }



   return 0;
}
// *****************************************************************************



void initADC( int amask)
{
    AD1PCFG = amask;		// select analog input pins
    AD1CON1 = 0x00E0;		// automatic conversion after sampling
    AD1CSSL = 0;		// no scanning required
    AD1CON2 = 0;		// use MUXA, AVss & AVdd used as vref +/-
    AD1CON3 = 0X1F01;		// Tad=2*(1+1)*Tpb=4*100ns>Tpb(min)=135ns
    AD1CON1bits.ADON = 1;	// turn on the ADC
}

int readADC( int ch)
{
    AD1CHSbits.CH0SA = ch;	// 1. select analog input
    AD1CON1bits.SAMP = 1;	// 2. start sampling
    while (!AD1CON1bits.DONE);	// 3. wait for conversion completion
    return ADC1BUF0;		// 4. read the conversion result	
}

void DelayInit()	
{
	unsigned int tcfg4;

	/* Configure Timer 4. This sets it up to count a 312500 Hz input clock 	*/
    
	tcfg4 = T4_ON|T4_SOURCE_INT|T4_PS_1_32;
	OpenTimer4(tcfg4, 0XFFFF);
	mT4ClearIntFlag();
}

void DelayMs(int cms)
{
	int		ims;
	for (ims=0; ims<cms; ims++) {
		WriteTimer4(0);
		while (ReadTimer4() < cntMsDelay);
	}
}


