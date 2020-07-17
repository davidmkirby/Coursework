#include <Wire.h>
#include "I2C_string.h"

void setup() {
  Wire.begin();

  Serial.begin(9600);
  while (!Serial); // Leonardo: wait for serial monitor
  
  int nDevices = 0;
  I2C_string fram = I2C_string();
  
  Serial.println("Scanning...");

  for (byte address = 1; address < 119; ++address) {
    // The i2c_scanner uses the return value of
    // the Write.endTransmission to see if
    // a device did acknowledge to the address.
    Wire.beginTransmission(address);
    byte error = Wire.endTransmission();

    if (error == 0) {
      Serial.print("I2C device discovered at address 0x");
      if (address < 16) {
        Serial.print("0");
      }
      Serial.print(address, HEX);Serial.println("!");
      uint16_t framAddr = address; // stores the discovered device address to be written/read
  
    if (fram.begin(framAddr)) {
    } else {
      Serial.println("No I2C devices discovered");
      while (1);
    }
   
   // Write 16-bit
   uint16_t test16 = 5000; // Test an arbitrary number too large for 8-bit
   Serial.print("\tWriting 16-bit number: ");Serial.print(test16);Serial.print(" to 0x");Serial.print(address, HEX);
   fram.write16(1,test16); //Writes to the second memory location
   
   // Read 16-bit
   Serial.print("\t\t\t\tReading 16-bit number: ");
   Serial.println(fram.read16(1));  //To read back as int or any other variable
                  //You can typecast by placing that type in front of
                  //fram.read16 ; ex. (int)fram.read16(0);
  
  // Write String
  String string_test = "The Quick Brown Fox";
  Serial.print("\tWriting String: "); Serial.print(string_test);Serial.print(" to 0x");Serial.print(address, HEX);
  fram.write_String(3,string_test);
  
  // Read String
  Serial.print("\t\t\tReading String: ");Serial.println(fram.read_String(3,string_test.length()+1));
  delay(1000); // hold for one second
  
  // Multiple Dynamic String Write and Read
  int string_Length1 = 0, string_Length2 = 0; // Place to store length of strings
  
  String string_test2 = "Jumps over the Lazy Dog!";
  Serial.print("\tWriting second String: ");Serial.print(string_test2);Serial.print(" to 0x");Serial.print(address, HEX);
  
  
  string_Length1 = string_test.length()+2; // get the length of the string to store
  string_Length2 = string_test2.length()+1; // add the plus one for string terminator
  
  fram.write8(1,string_Length1); // Save lengths in memory for read, when reading
  fram.write8(2,string_Length2); // back from memory with out knowing its length
  
  fram.write_String(2+fram.read8(1)+1,string_test2); // Start from beginning of the first string then add length of first string plus null
  delay(1000); // Give processor time to finish
  Serial.println("\t\tReading String: " + fram.read_String(3+fram.read8(1),fram.read8(2))); // repeat to read back using stored length
  delay(1000); // hold for a second
  
  // Total Message
  Serial.print("\tWhole Message:  ");
  Serial.print(fram.read_String(3,string_Length1)); // Use first memory location for string
  Serial.println(" " + fram.read_String(3+fram.read8(1),fram.read8(2)));

      ++nDevices; //count how many FRAMs we found
    } else if (error == 4) {
      Serial.print("Unknown error at address 0x");
      if (address < 16) {
        Serial.print("0");
      }
      Serial.println(address, HEX);
    }
  }
  if (nDevices == 0) {
    Serial.println("No I2C devices found\n");
  } else {
    Serial.print(nDevices);Serial.print(" I2C devices found\n");
    Serial.println("...done\n");
  }
//  delay(5000); // Wait 5 seconds for next scan
}

void loop() {
}