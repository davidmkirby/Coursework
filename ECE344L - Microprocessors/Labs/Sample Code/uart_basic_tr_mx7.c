/*********************************************************************
 *
 *      PIC32MX UART Interface Example
 *
 *********************************************************************
 * FileName:        uart_basic_tr_mx7.c
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

int main(void)
{
    unsigned int c;
    int char_in_flag;
 
    unsigned long int u2mode;
    unsigned long int u2status;
    
    u2mode = UART_EN | UART_IDLE_CON | UART_RX_TX |
                UART_DIS_WAKE | UART_DIS_LOOPBACK |
                UART_DIS_ABAUD | UART_NO_PAR_8BIT | UART_EN_BCLK |
                UART_1STOPBIT | UART_IRDA_DIS | UART_MODE_SIMPLEX |
                UART_NORMAL_RX | UART_BRGH_SIXTEEN;
    u2status = UART_TX_PIN_LOW | UART_RX_ENABLE | UART_TX_ENABLE;
    
//    u2mode = 0xb800;          // equivalent instructions
//    u2status = 0x1400;      
    
	// configured for 2400 baud
    OpenUART2(u2mode, u2status, 259);

    WriteUART2(62 );        // prompt
   
    while(1)
    {   
	// Wait for a character to be received
        
        // use a spin loop to wait for new input
        // when buffer is empty, return value is 0
     while( DataRdyUART2() == 0){

        }

        // now read the character in the buffer
       	c = ReadUART2();
        
        // echo the character
       	WriteUART2( c);        
    }

    return 0;
}
// *****************************************************************************
