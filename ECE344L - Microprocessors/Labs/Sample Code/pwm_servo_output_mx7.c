/*********************************************************************
 *
 *      PIC32MX PWM Output Demo
 *
 *********************************************************************
 * FileName:        pwm_servo_output_mx7.c
 * Dependencies:    plib.h
 *
 * Processor:       PIC32MX795F512L
 *
 *
 * 
 *********************************************************************
 * The purpose of this example code is to demonstrate using the PIC32MX
 * to drive servo motors using timer 1 to generate a syncorinizing interrupt
 * and providing varying pulse width outputs to the PMOD connector that will
 * be connected to the servo interface unit.
 * The servo interface unit is driven by digital IO ports
 * rather than the output compare modules that can also generate PWM signals.
 *
 * Platform: ChipKIT MX7
 *
 * Features demonstrated:
 *    - timer driven PWM signals
 *    - Use of the c peripheral library functions
 *
 * Description:
 *      This program allows a user to vary the pulse width of signals
 *      that connect to the servo motor connector bank on the MX7 board.
 *      The pulse width is controlled by a potentiometer connected to AN4,
 *      converted by the ADC to binary value, which is then
 *      used to vary the time during which the output pulse is high.
 *      The period of the PWM signal is controlled by timer 1.
 *
 ********************************************************************/
/*  Modified: 11/25/2018 by E.J. Nava, University of New Mexico
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

#define	cntMsDelay	312			// timer 4 delay for 1ms
													
#define POT 4			    		// analog input on AN4
#define AINPUTS 0xffef		// set all bits 1 except for AN5 line
#define ADC_COUNT 1023		// number of values represented by ADC
#define VMAX 3.2		    // Vref +
#define VMIN 0.0		    // Vref -

// global vaiables
int servoflag = 0;      // used in main program to indicate PWM generation

// function prototypes
void initADC( int amask);
int readADC( int c);
void T1Init();
void DelayInit();
void Delay(short int counts);
void DeviceInit();

void __ISR(_TIMER_1_VECTOR, ipl2) Timer1Handler(void)
{
	// clear the interrupt flag
	mT1ClearIntFlag();
    // set the servo flag;
	  servoflag = 1;
}

int main(void)
{
    extern int servoflag;       // indicator to start PWM delays    
    unsigned int tcfg2;         // timer configuration word
    unsigned int adc_value;     // adc input value 0..0x400
		short int counts1;				// timer value for servo pulse 1 width

    //initialize timer 1 for interrupt operation to drive servos
    T1Init();
    
    //initialize output port G for servo control signal
    // **** TEST with PORT B *****
    DeviceInit();
    
    //initialize timer 4 for delay
    DelayInit();

   // initialize the ADC   
    initADC(AINPUTS);		    // initialize the ADC
    
    // sample and OC1 duty cycle control loop
    
    while (1) {
       	// read data from ADC
        adc_value = readADC(POT);   // selecct POT input as integer
			counts1 = 180 + (short int) (adc_value*4);
//        SetDCOC1PWM(adc_value);     // set duty cycle as set by potentiometer
        if(servoflag) {
            PORTSetBits(IOPORT_D,BIT_1);
            Delay(counts1);				// Here is where you implement a
									// variable delay of 1.0 to 2.0 mSec
									// using the value from the ADC
									// connect the servo motor to servo
									// block connector one.
            PORTClearBits(IOPORT_D,BIT_1);
            servoflag = 0;
        }
       
	}
   return 0;
}
// *****************************************************************************

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
    AD1CHSbits.CH0SA = ch;	// 1. select analog input
    AD1CON1bits.SAMP = 1;	// 2. start sampling
    while (!AD1CON1bits.DONE);	// 3. wait for conversion completion
    return ADC1BUF0;		// 4. read the conversion result	
}

void DelayInit()	
{
	unsigned int tcfg4;
	/* Configure Timer 4. This sets up to count 312500 Hz clk with a preset of 0xFFFF */
	tcfg4 = T4_ON|T4_SOURCE_INT|T4_PS_1_32;
	OpenTimer4(tcfg4, 0XFFFF);
	mT4ClearIntFlag();
}

void T1Init()	
{
	unsigned int tcfg1;

	/* Config Timer 1. This sets it to count 1.25 MHz with a period of 20 mSec 	*/
	tcfg1 = T1_ON|T1_SOURCE_INT|T1_PS_1_8;
	OpenTimer1(tcfg1, 0x61a8);
	
	/* Now enable system-wide multi-vector interrrupt handling	*/
	INTEnableSystemMultiVectoredInt();
	
	/* configure timer 1 interrupt with priority of 2	*/
	ConfigIntTimer1(T1_INT_ON | T1_INT_PRIOR_2);
	
	/* Clear interrupt flag	*/
	mT1ClearIntFlag();

}

void Delay(short int counts)
{
		WriteTimer4(0);
		while (ReadTimer4() < counts);
}

void DeviceInit()
{
	//Set ports for servo pin output
	PORTSetPinsDigitalOut(IOPORT_D, BIT_1);
}

