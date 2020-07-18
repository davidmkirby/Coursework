/**************************************************************************/
/*!
    @file     Adafruit_FRAM_I2C.cpp
    @author   KTOWN (Adafruit Industries)
    @license  BSD (see license.txt)

    Driver for the Adafruit I2C FRAM breakout.

    Adafruit invests time and resources providing this open source code,
    please support Adafruit and open-source hardware by purchasing
    products from Adafruit!

    @section  HISTORY

    v1.0 - First release
    v1.1 - 16-bit expansion using bitwise operation
*/
/**************************************************************************/
//#include <avr/pgmspace.h>
//#include <util/delay.h>
#include <stdlib.h>
#include <math.h>

#include "I2C_string.h"

/*========================================================================*/
/*                            CONSTRUCTORS                                */
/*========================================================================*/

/**************************************************************************/
/*!
    Constructor
*/
/**************************************************************************/
I2C_string::I2C_string(void) 
{
  _framInitialised = false;
}

/*========================================================================*/
/*                           PUBLIC FUNCTIONS                             */
/*========================================================================*/

/**************************************************************************/
/*!
    Initializes I2C and configures the chip (call this function before
    doing anything else)
*/
/**************************************************************************/
boolean I2C_string::begin(uint8_t addr) 
{
	
  i2c_addr = addr;
  Wire.begin();
  
  /* Make sure we're actually connected */
  uint16_t manufID, prodID;
  getDeviceID(&manufID, &prodID);
  if (manufID != 0x00A)
  {
    Serial.print("Unexpected Manufacturer ID: 0x");
    Serial.println(manufID, HEX);
    return false;
  }
  if (prodID != 0x510)
  {
    Serial.print("Unexpected Product ID: 0x");
    Serial.println(prodID, HEX);
    return false;
  }

  /* Everything seems to be properly initialised and connected */
  _framInitialised = true;

  return true;
}

/**************************************************************************/
/*!
    @brief  Writes a byte at the specific FRAM address
    
    @params[in] i2cAddr
                The I2C address of the FRAM memory chip (1010+A2+A1+A0)
    @params[in] framAddr
                The 16-bit address to write to in FRAM memory
    @params[in] i2cAddr
                The 8-bit value to write at framAddr
*/
/**************************************************************************/
void I2C_string::write8 (uint16_t framAddr, uint8_t value)
{
  Wire.beginTransmission(i2c_addr);
  Wire.write(framAddr >> 8);
  Wire.write(framAddr & 0xFF);
  Wire.write(value);
  Wire.endTransmission();
}

/**************************************************************************/
/*!
    @brief  Reads an 8-bit value from the specified FRAM address

    @params[in] i2cAddr
                The I2C address of the FRAM memory chip (1010+A2+A1+A0)
    @params[in] framAddr
                The 16-bit address to read from in FRAM memory

    @returns    The 8-bit value retrieved at framAddr
*/
/**************************************************************************/
uint8_t I2C_string::read8 (uint16_t framAddr)
{
  Wire.beginTransmission(i2c_addr);
  Wire.write(framAddr >> 8);
  Wire.write(framAddr & 0xFF);
  Wire.endTransmission();

  Wire.requestFrom(i2c_addr, (uint8_t)1);
  
  return Wire.read();
}

/**************************************************************************/
/*!
    @brief  Reads the Manufacturer ID and the Product ID frm the IC

    @params[out]  manufacturerID
                  The 12-bit manufacturer ID (Fujitsu = 0x00A)
    @params[out]  productID
                  The memory density (bytes 11..8) and proprietary
                  Product ID fields (bytes 7..0). Should be 0x510 for
                  the MB85RC256V.
*/
/**************************************************************************/
void I2C_string::getDeviceID(uint16_t *manufacturerID, uint16_t *productID)
{
  uint8_t a[3] = { 0, 0, 0 };
  uint8_t results;
  
  Wire.beginTransmission(MB85RC_SLAVE_ID >> 1);
  Wire.write(i2c_addr << 1);
  results = Wire.endTransmission(false);

  Wire.requestFrom(MB85RC_SLAVE_ID >> 1, 3);
  a[0] = Wire.read();
  a[1] = Wire.read();
  a[2] = Wire.read();

  /* Shift values to separate manuf and prod IDs */
  /* See p.10 of http://www.fujitsu.com/downloads/MICRO/fsa/pdf/products/memory/fram/MB85RC256V-DS501-00017-3v0-E.pdf */
  *manufacturerID = (a[0] << 4) + (a[1]  >> 4);
  *productID = ((a[1] & 0x0F) << 8) + a[2];
}

/**************************************************************************/
/*!
    @brief  Writes a 16-bit value to the specified FRAM address

    @params[in] framAddr
                The I2C address of the FRAM memory chip (1010+A2+A1+A0)
    @params[in] value1
                The 16-bit value to be written

*/
/**************************************************************************/
void I2C_string::write16(uint16_t framAddr, uint16_t value1)
{
	int c_address = framAddr+framAddr;
	uint16_t low,high;
	low=value1 & 0x00FF;
	high=value1 & 0xFF00;
	high= high >> 8;
	
	write8(c_address, low);
	write8(c_address+1, high);
}

/**************************************************************************/
/*!
    @brief  Reads a 16-bit value from the specified FRAM address

    @params[in] framAddr
                The 8-bit address to read from in FRAM memory

    @returns    The 16-bit value retrieved at framAddr
*/
/**************************************************************************/
uint16_t I2C_string::read16(uint16_t framAddr)
{
	int c_address = framAddr+framAddr;
	uint16_t low;
	uint16_t high;
	low = read8(c_address);//& 0xff;
	high = read8(c_address+1);// << 8;

	uint16_t temp1 = 256*high+low;

	return twos_comp_check(temp1);
}

/**************************************************************************/
/*!
    @brief  Checks to see if signed value is negative or positive

    @params[in] number
                The value to be checked

    @returns    The value as either a correct negative number or a positive
*/
/**************************************************************************/
uint16_t I2C_string::twos_comp_check(uint16_t number)
{
	uint16_t numcheck = 0, number2 = number&0xFFFF;

	numcheck = number2 >>15;
	

	if(numcheck == 0)
	{
		return number;
	}
	else
	{
		number2 = number2^0xFFFF;
		return -(number2+1);
	}

}

/**************************************************************************/
/*!
    @brief  Reads a string from the specified FRAM address

    @params[in] Addr
                The I2C address of the FRAM memory chip (1010+A2+A1+A0)
    @params[in] length
                The length of the string being read

    @returns    The string read from starting address ending at length
*/
/**************************************************************************/
String I2C_string::read_String(int Addr, int length)
{
	char temparray[length];
	for(int i=0;i<length;i++)
	{
		temparray[i]= (char)read8(Addr+i);
	}
	String stemp(temparray);
	
	return stemp;
	
}

/**************************************************************************/
/*!
    @brief  Writes string to the specified FRAM address

    @params[in] Addr
                The I2C address of the FRAM memory chip (1010+A2+A1+A0)
    @params[in] input
                The String to be written to FRAM memory

*/
/**************************************************************************/
void I2C_string::write_String(int Addr, String input)
{
	int numBytes;
	char cbuff[input.length()+1];
	input.toCharArray(cbuff,input.length()+1);
	for (int i = 0; i < input.length()+1; i++) {
		write8(Addr + i,cbuff[i]);
	}
	
}