## Adafruit I2C FRAM 16-bit Strings ##

This driver is for the [Adafruit I2C FRAM](https://www.adafruit.com/product/1895) breakout.

Install this library & example by downloading the .zip file from this Git and unzipping it into your Arduino > Library folder ([more info here](https://www.arduino.cc/en/Guide/Libraries)). 

## About this Driver ##

These modules use I2C to communicate, two pins are required to interface.

Adafruit I2C breakouts use MB85RC256V FRAMs and are only able to write 8 bits of data per memory location. To write 16 bits to the memory, a function (write16) takes a 16-bit variable and splits it into two parts then saves the two 8-bit halves into two adjacent memory locations. This allows them to be concatenated using [bitwise operations](https://en.wikipedia.org/wiki/Bitwise_operation).

Memory addresses may be changed by driving the different pins higher as explained by Adafruit [here](https://learn.adafruit.com/adafruit-i2c-fram-breakout/pinouts#i2c-logic-pins-2-3):

Library, inspiration, and thanks go out to [Mario](http://mario.mtechcreations.com/programing/my-adafruit-fram-i2c-plus-library/):
