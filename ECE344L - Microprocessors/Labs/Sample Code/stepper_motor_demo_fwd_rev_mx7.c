/*********************************************************************
 *
 *      PIC32MX PWM Output Demo
 *
 *********************************************************************
 * FileName:        stepper_motor_demo_fwd_rev_mx7.c
 * Dependencies:    plib.h
 *
 * Processor:       PIC32MX795F512L
 *
 *
 * 
 *********************************************************************
 * The purpose of this example code is to demonstrate the PIC32MX
 * peripheral library macros and functions to generate the phased
 * outputs needed to drive a stepper motor.  This version uses the
 * on-board lEDs to demonstrate the phases being energized and an external
 * stepper PMOD interface to drive the motor.
 *
 * Platform: ChipKIT MX7
 *
 * Features demonstrated:
 *    - phased outputs that would be used to drive a stepper
 *    - motor in either the forward or reverse direction
 *    - Use of the c peripheral library functions
 *
 * Description:
 *      This program steps through the sequence of phase energizing
 *      that is applied to a stepper motor to cause it to rotate in
 *      either a clockwise, or counter clockwise direction.
 *
 *      This version runs in a continuous mode where the speed of
 *      rotation is controlled by setting the timer delay and the
 *      direction is set by a variable at the beginning of the
 *      execution, but the program can be modified to change the
 *      direction in real-time and the sequencing of the phases will
 *      be continuous.
 *
 *      The program uses timer 4 to implement a delay function.
 *
 ********************************************************************/
/*  Modified: 12/1/2108 by E.J. Nava, University of New Mexico
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

// function prototypes
void DeviceInit();
void DelayInit();
void DelayMs(int cms);


int main(void)
{
    int speed = 5;         // value used to control delay
							// smaller number - faster rotation
    int forward = 1;
    int step = 1;
    //initialize timer for delay
    DelayInit();
    // initiailize I/O Ports
    DeviceInit();
    
    
    while (1) {
      
      // seguence for rotating the stepper motor in half step mode
      // in the forward direction
      if (forward) {
        switch (step) {                    // Forward direction
          case 1:
             PORTWrite(IOPORT_G, 0x8000);  // step 1
             PORTWrite(IOPORT_E, 0x88);    // step 1
             step = 2;
             break;
          case 2:
              PORTWrite(IOPORT_G, 0xC000);  // step 2
              PORTWrite(IOPORT_E, 0xCC);    // step 2
              step = 3;
              break;
          case 3:
              PORTWrite(IOPORT_G, 0x4000);  // step 3
              PORTWrite(IOPORT_E, 0x44);    // step 3
              step = 4;
              break;
          case 4:
              PORTWrite(IOPORT_G, 0x6000);  // step 4
              PORTWrite(IOPORT_E, 0x66);    // step 4
              step = 5;
              break;
          case 5:
              PORTWrite(IOPORT_G, 0x2000);  // step 5
              PORTWrite(IOPORT_E, 0x22);    // step 5
              step = 6;
              break;
          case 6:
              PORTWrite(IOPORT_G, 0x3000);  // step 6
              PORTWrite(IOPORT_E, 0x33);    // step 6
              step = 7;
              break;
          case 7:
              PORTWrite(IOPORT_G, 0x1000);  // step 7
              PORTWrite(IOPORT_E, 0x11);    // step 7
              step = 8;
              break;
          case 8:
              PORTWrite(IOPORT_G, 0x9000);  // step 8
              PORTWrite(IOPORT_E, 0x99);    // step 8
              step = 1;
              break;
          default:
              step = 1;
          }
      DelayMs(speed); 
      }
      else {
        switch (step) {                    // Reverse operation
          case 1:
             PORTWrite(IOPORT_G, 0x8000);  // step 1
             PORTWrite(IOPORT_E, 0x88);    // step 1
             step = 8;
             break;
          case 2:
              PORTWrite(IOPORT_G, 0xC000);  // step 2
              PORTWrite(IOPORT_E, 0xCC);    // step 2
              step = 1;
              break;
          case 3:
              PORTWrite(IOPORT_G, 0x4000);  // step 3
              PORTWrite(IOPORT_E, 0x44);    // step 3
              step = 2;
              break;
          case 4:
              PORTWrite(IOPORT_G, 0x6000);  // step 
              PORTWrite(IOPORT_E, 0x66);    // step 4
              step = 3;
              break;
          case 5:
              PORTWrite(IOPORT_G, 0x2000);  // step 5
              PORTWrite(IOPORT_E, 0x22);    // step 5
              step = 4;
              break;
          case 6:
              PORTWrite(IOPORT_G, 0x3000);  // step 6
              PORTWrite(IOPORT_E, 0x33);    // step 6
              step = 5;
              break;
          case 7:
              PORTWrite(IOPORT_G, 0x1000);  // step 7
              PORTWrite(IOPORT_E, 0x11);    // step 7
              step = 6;
              break;
          case 8:
              PORTWrite(IOPORT_G, 0x9000);  // step 8
              PORTWrite(IOPORT_E, 0x99);    // step 8
              step = 7;
              break;
          default:
              step = 1;
          }              
       DelayMs(speed);        
      }
    }



   return 0;
}
// *****************************************************************************


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

void DeviceInit()
{
 // On MX7 board, disable JTAG function
  DDPCONbits.JTAGEN = 0;
  
	//  On MX7 LED1 is on RG12
	//		   LED2 is on RG13
	//		   LED3 is on RG14
	//		   LED4 is on RG15
	//Set ports for onboard LEDs to outputs & claer them
	PORTSetPinsDigitalOut (IOPORT_G, BIT_12|BIT_13| BIT_14|BIT_15);
	PORTClearBits(IOPORT_G,BIT_12|BIT_13| BIT_14|BIT_15);
    
    //Set ports for PMOD connector B
	PORTSetPinsDigitalOut (IOPORT_E, BIT_0|BIT_1| BIT_2|BIT_3|
                           BIT_4|BIT_5|BIT_6|BIT_7);
     //Clear Port bits
	PORTClearBits(IOPORT_E, BIT_0|BIT_1| BIT_2|BIT_3|
                           BIT_4|BIT_5|BIT_6|BIT_7);

 
}

