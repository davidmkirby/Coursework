/**************************************************************************************/
/*
/*  Authors:        Diego Chavez, David Kirby, John Quinlan
/*
/*  Description:    K1 disinfectant tank communication system
/*
/*  History:
/*                  v1.0 - 2015 Senior Design Group
/*                          Created LED displays for error detection
/*                  v2.0 - 2020 Senior Design Group
/*                          Added FRAM storage, LCD, and alert notification system
/*
/**************************************************************************************/

//included library section
#include <Wire.h>
#include <LiquidCrystal_PCF8574.h>
#include <SoftwareSerial.h>
#include "I2C_string.h" //Local library for strings in FRAM
//#include <SIM800.h>

//Initialization of FRAMs as string reads
I2C_string fram = I2C_string();
I2C_string fram1 = I2C_string();

//LCD display with address 0x27
LiquidCrystal_PCF8574 lcd(0x27);

//For requirements 5 and 6
int ampsec = 0;
int liters = 0;

//Analog button values
const int LL_AB = 678;
const int LM_AB = 611;
const int RM_AB = 509;
const int RR_AB = 339;

//Analog inputs
int SCLA5 = 24;
int SDAA4 = 23;
int CV4 = 22;
int TEMP1 = 21;
int CIV = 20;
int A0_Mux = A0;
int ReadA0 = 0;

//Demuxing digital pins
const int D0A = 5;
const int D1B = 6;
const int D2C = 7;
const int D3D = 8;

//digital pins definiton
const int DBG0 = 9;
const int DBG1 = 10;
const int D0X0 = 11;
const int D0X1 = 12;
const int D0T0 = 13;
const int D0T1 = 14;

//Global language. Set default as English, can be changed through language select.
String Select = "Language Select";
String BeginDisinfection = "Begin Disinfection";
String ErrorMessage = "Error Message";
String QUIT = "Quit";

//Count the number of times the cell has been used.
//Will reverse polarity every 10 times in requirement 11.
uint8_t PolarityTest;

void setup(void)
{
  //SMS set up, uncomment when fixed
  //SendSMSsetup();
  //Start FRAM i2c set up
  //Baud rate
  Serial.begin(9600);
  while (!Serial)
    ;
  {
    Serial.print("Waiting for Serial\n");
  }
  // Analog pin set up
  pinMode(A0_Mux, INPUT);
  pinMode(SCLA5, INPUT);
  pinMode(SDAA4, INPUT);
  pinMode(CV4, INPUT);
  pinMode(TEMP1, INPUT);
  pinMode(CIV, INPUT);

  //Pin Outs and Ins -------------------------------------------------------------------
  //The Mux pins
  pinMode(D0A, OUTPUT);
  pinMode(D1B, OUTPUT);
  pinMode(D2C, OUTPUT);
  pinMode(D3D, OUTPUT);

  //Other digital pins
  pinMode(DBG0, INPUT);
  pinMode(DBG1, INPUT);
  pinMode(D0X0, INPUT);
  pinMode(D0X1, INPUT);
  pinMode(D0T0, INPUT);
  pinMode(D0T1, INPUT);

  //Check the first FRAM
  if (fram1.begin(0x51))
  {
    Serial.println("Found I2C FRAM 0x51");
  }
  else
  {
    Serial.println("I2C FRAM not identified 0x51 ... check your connections?\r\n");
    alarm(0);
  }
  //Check the second FRAM
  if (fram.begin(0x50))
  { // you can stick the new i2c addr in here, e.g. begin(0x51);
    Serial.println("Found I2C FRAM 0x50");
  }
  else
  {
    Serial.println("I2C FRAM not identified 0x50... check your connections?\r\n");
    alarm(0);
  }
  //LCD set up ------------------------------------------------------------------------
  int error;
  Serial.println("LCD...\n");
  Serial.println("check for LCD");
  Wire.begin();
  Wire.beginTransmission(0x27);
  error = Wire.endTransmission();
  if (error == 0)
  {
    uint8_t test = fram.read8(0x0);
    Serial.println(": LCD found \n");
    lcd.begin(16, 2); // initialize the lcd
  }
  else
  {
    Serial.println(": LCD not found.");
    alarm(0);
  }
  lcd.setBacklight(255);
  lcd.home();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Hello LCD");
  lcd.setCursor(0, 1);
  delay(1000);
  lcd.clear();
  lcd.setBacklight(0);
}

void correctA0() //Corrects inconsistencies reading analog button
{
  //int LL_AB=678;
  //int LM_AB=611;
  //int RM_AB=509;
  //int RR_AB=339;
  if (ReadA0 < 686 && ReadA0 > 669)
  {
    ReadA0 = LL_AB;
  }
  else if (ReadA0 < 616 && ReadA0 > 609)
  {
    ReadA0 = LM_AB;
  }
  else if (ReadA0 < 511 && ReadA0 > 504)
  {
    ReadA0 = RM_AB;
  }
  else if (ReadA0 < 346 && ReadA0 > 330)
  {
    ReadA0 = RR_AB;
  }
  else
  {
    ReadA0 = 0;
  }
}
//Main loop ------------------------------------------------------------------------
void loop(void)
{
  ReadA0 = 0; //set the read A0 to zero.
  delay(1000);
  //default state selected
  int SelectOption = 1;
  LCDdis("->" + Select, BeginDisinfection, ErrorMessage, QUIT);

  //wait until button pushed
  while (ReadA0 != RM_AB)
  {
    ReadA0 = 0;
    while (ReadA0 < 10)
    {
      updateMuxA0();
      correctA0();
      //Serial.println(ReadA0);
      //delay(10);
    }
    //based on selected state go to function
    if (ReadA0 == LL_AB)
    {
      SelectOption -= 1;
    }
    if (ReadA0 == LM_AB)
    {
      SelectOption += 1;
    }
    if (SelectOption < 0)
    {
      SelectOption = 4;
    }
    if (SelectOption > 4)
    {
      SelectOption = 1;
    }

    //Selects function based on state
    switch (SelectOption)
    {
    case 1:
      LCDdis("->" + Select, BeginDisinfection, ErrorMessage, QUIT);
      break;
    case 2:
      LCDdis(Select, "->" + BeginDisinfection, ErrorMessage, QUIT);
      break;
    case 3:
      LCDdis(Select, BeginDisinfection, "->" + ErrorMessage, QUIT);
      break;
    case 4:
      LCDdis(Select, BeginDisinfection, ErrorMessage, "->" + QUIT);
      break;
    default:
      //Should not be able to get here
      Serial.println("error");
      break;
    }
    //Serial.println(ReadA0);
  }
  //Goes to the selected function
  switch (SelectOption)
  {
  case 1:
    Hello_Phase();
    break;
  case 2:
    Requirement10();
    break;
  case 3:
    errorMSG();
    break;
  case 4:
    //this is quit. needs a function to begin
    LCDdis("Language Select", "Begin Disinfection", "Error Messages", "->Quit");
    break;
  default:
    Serial.println("error");
    break;
  }
}

//Updates ReadA0 based on what user presses
void updateMuxA0()
{
  ReadA0 = analogRead(A0_Mux);
}

//Takes four strings and displays them.
void LCDdis(String a, String b, String c, String d)
{
  lcd.setBacklight(100);
  lcd.home();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(a);
  lcd.setCursor(0, 1);
  lcd.print(b);
  lcd.setCursor(0, 2);
  lcd.print(c);
  lcd.setCursor(0, 3);
  lcd.print(d);
  delay(100);
}

//Language select
void Hello_Phase(void)
{
  ReadA0 = 0;
  delay(1000);
  int Selectt = 1;
  LCDdis(Select, "", "<-   English   ->", "");

  //While menu has not been selected
  while (ReadA0 != RM_AB)
  {
    Read_AB();
    correctA0();
    if (ReadA0 == RR_AB)
    {
      return;
    }

    if (ReadA0 == LL_AB)
    {
      Selectt -= 1;
    }
    if (ReadA0 == LM_AB)
    {
      Selectt += 1;
    }
    if (Selectt < 0)
    {
      Selectt = 4;
    }
    if (Selectt > 4)
    {
      Selectt = 1;
    }

    //Displays language options
    switch (Selectt)
    {
    case 1:
      LCDdis(Select, "", "<-   English   ->", "");
      break;
    case 2:
      LCDdis(Select, "", "<-    Spanish    ->", "");
      break;
    case 3:
      LCDdis(Select, "", "<-    French    ->", "");
      break;
    case 4:
      LCDdis(Select, "", "<-   Dutch    ->", "");
      break;
    default:
      Serial.println("error");
      break;
    }
  }
  //Change the global strings based on language
  switch (Selectt)
  {
  case 1:
    //English
    LanguageChange(0, 0);
    break;
  case 2:
    //Spanish
    LanguageChange(0, 80);
    break;
  case 3:
    //French
    LanguageChange(1, 0);
    break;
  case 4:
    //Dutch
    LanguageChange(1, 80);
    break;
  default:
    Serial.println("error");
    break;
  }
  return;
}

//Changes how to read the FRAM. Will need to change if you change languages in the FRAM
void LanguageChange(int a, int b)
{
  if (a == 0)
  {
    Select = fram.read_String(b + 0, 19);
    BeginDisinfection = fram.read_String(b + 20, 19);
    ErrorMessage = fram.read_String(b + 40, 19);
    QUIT = fram.read_String(b + 60, 19);
  }

  if (a == 1)
  {
    Select = fram1.read_String(b + 0, 19);
    BeginDisinfection = fram1.read_String(b + 20, 19);
    ErrorMessage = fram1.read_String(b + 40, 19);
    QUIT = fram1.read_String(b + 60, 19);
  }
}

//Waits for a button to be pressed by the user
void Read_AB(void)
{
  ReadA0 = 0;
  while (ReadA0 < 10)
  {
    updateMuxA0();
    //Serial.println(ReadA0);
  }
}

//Demuxing states. Will take argument int and output configuration in demux binary
void Actuators(int var)
{
  switch (var)
  {
  case 0: //Solenoid Valve 1
    digitalWrite(D0A, LOW);
    digitalWrite(D1B, LOW);
    digitalWrite(D2C, LOW);
    digitalWrite(D3D, LOW);
    break;

  case 1: //Solenoid Valve 2
    digitalWrite(D0A, HIGH);
    digitalWrite(D1B, LOW);
    digitalWrite(D2C, LOW);
    digitalWrite(D3D, LOW);
    break;

  case 2: //Solenoid Valve 3
    digitalWrite(D0A, LOW);
    digitalWrite(D1B, HIGH);
    digitalWrite(D2C, LOW);
    digitalWrite(D3D, LOW);
    break;

  case 3: //Solenoid Valve 4
    digitalWrite(D0A, HIGH);
    digitalWrite(D1B, HIGH);
    digitalWrite(D2C, LOW);
    digitalWrite(D3D, LOW);
    break;

  case 4: //CELL ON
    digitalWrite(D0A, LOW);
    digitalWrite(D1B, LOW);
    digitalWrite(D2C, HIGH);
    digitalWrite(D3D, LOW);
    break;

  case 5: //Cell Polarity
    digitalWrite(D0A, HIGH);
    digitalWrite(D1B, LOW);
    digitalWrite(D2C, HIGH);
    digitalWrite(D3D, LOW);
    break;

  case 6: //Alarm
    digitalWrite(D0A, LOW);
    digitalWrite(D1B, HIGH);
    digitalWrite(D2C, HIGH);
    digitalWrite(D3D, LOW);
    break;

  case 7: //Green LED
    digitalWrite(D0A, HIGH);
    digitalWrite(D1B, HIGH);
    digitalWrite(D2C, HIGH);
    digitalWrite(D3D, LOW);
    break;

  case 8: //Yello LED
    digitalWrite(D0A, LOW);
    digitalWrite(D1B, LOW);
    digitalWrite(D2C, LOW);
    digitalWrite(D3D, HIGH);
    break;

  case 9: //red LED
    digitalWrite(D0A, HIGH);
    digitalWrite(D1B, LOW);
    digitalWrite(D2C, LOW);
    digitalWrite(D3D, HIGH);
    break;

  case 10: //empty do nothing
    digitalWrite(D0A, LOW);
    digitalWrite(D1B, HIGH);
    digitalWrite(D2C, LOW);
    digitalWrite(D3D, HIGH);
    break;

  case 11: //empty do nothing
    digitalWrite(D0A, HIGH);
    digitalWrite(D1B, HIGH);
    digitalWrite(D2C, LOW);
    digitalWrite(D3D, HIGH);
    break;

  case 15: //default off state
    digitalWrite(D0A, HIGH);
    digitalWrite(D1B, HIGH);
    digitalWrite(D2C, LOW);
    digitalWrite(D3D, HIGH);
    break;

  default:
    Serial.print("Error. Incorrect demux state.\n");
    delay(1);
    break;
  }
}

//Code based off the 2015 K1 requirements, but "interpreted" to fit the new board
//Requirement 1
int Requirement1(void)
{
  LCDdis("Requirement 1", "started", "", "");
  delay(300);

  //Full state no error but alarm
  if (readD(D0T0) == 1 && readD(D0T1) == 1)
  {
    alarm(1);
    return 1;
  }

  //Error state defaults
  if (readD(D0T0) == 0 && readD(D0T1) == 1 || readD(DBG0) == 0 &&
      readD(DBG1) == 1 || readD(D0X0) == 0 && readD(D0X1) == 1)
  {
    alarm(3);
    return 1;
  }
  //Empty state = tell user to check tanks
  if (readD(DBG0) == 0 && readD(DBG1) == 0 || readD(D0X0) == 0 && readD(D0X1) == 0)
  {
    alarm(2);
    return 1;
  }

  //Start state = no error
  if (readD(D0T1) == 0 && readD(D0T0) == 1 || readD(D0T1) == 0 && readD(D0T0) == 0)
  {
    Serial.print("start state in req1\n"); //Turn system on
    delay(5000);
    Actuators(4); //Turn on cell
    return 0;     //Return with no error
  }
}

int Requirement2(void)
{
  LCDdis("Requirement 2", "started", "", "");
  Actuators(0);            //Turn on solenoid valve 1
  while (readD(DBG1) == 1) //while empty wait to fill
  {
    //do nothing}
    delay(160);
    Serial.print("in Req2 waiting for BG1\n");
  }
  //error state
  if (readD(DBG1) == 1 && readD(DBG0) == 0)
  {
    alarm(3);
    return 1;
  }
  Serial.print("Req2 success\n");
  //no error reported. turn off everything
  Actuators(15);
  return 0;
}

int Requirement3(void)
{
  LCDdis("Requirement 3", "started", "", "");
  delay(1600);
  Actuators(1);                                //Turn on solenoid valve 1
  while (readD(D0X0) != 1 && readD(D0X1) != 1) //While not full
  {

    if (readD(D0X0) == 0 && readD(D0X1) == 1) //error state in sensors
    {
      alarm(3);
      return 1;
    }
    delay(1);
  }
  Actuators(15);
  return 0;
}

void Requirement4(void)
{
  LCDdis("Requirement 4", "started", "", "");
  //Cell on
  Actuators(4);
  delay(5000);
  //Actuators(15);
}

//Read amps-sec and output as liters. Not defined yet by Tim
int Requirement56(void)
{
  LCDdis("Requirement 56", "started", "", "");
  int Temp = 0;
  int sec = 0;

  //While amp-sec is less than a certain value
  while (ampsec < 100)
  {
    delay(1000);
    Temp = analogRead(CIV);
    //Error if CIV amperage is very low
    if (analogRead(Temp <= 1))
    {
      alarm(4);
      return 1;
    }
    //Error if CIV is way to high
    if (analogRead(Temp >= 5))
    {
      alarm(5);
      return 1;
    }

    ampsec = Temp * sec;
    //100? 100 is supposed to be charge
    sec += 1;
  }
  return 0;
}

//Turn off everything
void Requirement7(void)
{
  LCDdis("Requirement 10", "started", "", "");
  Actuators(15);
}

int Requirement89(void)
{
  LCDdis("Requirement 89", "started", "", "");
  Actuators(2);                                //Turn on solenoid valve 3
  while (readD(D0X0) != 0 && readD(D0X1) != 0) //While not empty
  {
    //Checking errors in sensors
    if (readD(D0T0) == 0 && readD(D0T1) == 1 || readD(DBG0) == 0 &&
        readD(DBG1) == 1 || readD(D0X0) == 0 && readD(D0X1) == 1)
    {
      alarm(3);
      return 1;
    }
    delay(1000);
  }
  //Turn off everything and report no error
  Actuators(15);
  return 0;
}
//Change polarity every ten uses. Saves to fram and counts between shut-offs
void Requirement11(void)
{
  LCDdis("Requirement 11", "started", "", "");
  //Read from address in FRAM
  PolarityTest = fram.read8(0xFF);
  if (PolarityTest > 9) //If greater then 9, reset
  {
    Actuators(10);
    PolarityTest = 0;
    delay(1000);
    Actuators(15);
  }
  PolarityTest += 1;
  fram.write8(0xFF, PolarityTest); //Save state to FRAM
}
//Generating
void Requirement10(void)
{
  LCDdis("Requirement 10", "started", "", "");
  delay(3000);
  //Tank full
  if (readD(D0T1) == 1 && readD(D0T0) == 1)
  {
    LCDdis("Oxidant Tank Full", "Empty Please", "", "");
    return;
  }
  //Error states for sensors
  if (readD(D0T0) == 0 && readD(D0T1) == 1 || readD(DBG0) == 0 &&
      readD(DBG1) == 1 || readD(D0X0) == 0 && readD(D0X1) == 1)
  {
    alarm(3);
    return;
  }
  //Error states for empty tanks
  if (readD(DBG0) == 0 && readD(DBG1) == 0 || readD(D0X0) == 0 && readD(D0X1) == 0)
  {
    alarm(2);
    return;
  }
  //While OT tank is not full, generate
  while (readD(D0T1) != 1 && readD(D0T0) != 1)
  {
    //If a state returns 1, it will exit this function
    if (Requirement1() == 1)
    {
      return;
    }
    if (Requirement2() == 1)
    {
      return;
    }
    if (Requirement3() == 1)
    {
      return;
    }
    Requirement4();
    if (Requirement56() == 1)
    {
      return;
    }
    Requirement7();
    if (Requirement89() == 1)
    {
      return;
    }
    Requirement11();
  }
}
//Reads a digital pin
int readD(int digital)
{
  return digitalRead(digital);
}

//Converts the ampseconds to liters for output
void ampsecliters(void)
{
  if (ampsec > 2)
  {
    liters = 20;
  }
  if (ampsec > 1.5)
  {
    liters = 15;
  }
  if (ampsec > 1)
  {
    liters = 10;
  }
  if (ampsec > .5)
  {
    liters = 5;
  }
}
//Activate alarm if conditions are met
void alarm(int a)
{
  uint8_t temp = 0;
  //Activate alarm
  Actuators(6);
  //Turn on red light
  Actuators(10);
  //Record error, tell user what is wrong, send SMS
  switch (a)
  {
  //Start up error
  case 0:
    LCDdis0();
    temp = fram1.read8(0xF8);
    temp += 1;
    fram1.write8(0xF8, temp);
    //sendSMS((char) 0xF8);
    break;

  //Full alarm
  case 1:
    LCDdis1();
    temp = fram1.read8(0xF9);
    temp += 1;
    fram1.write8(0xF9, temp);
    //sendSMS((char) 0xF9);
    break;

  //Empty error
  case 2:
    LCDdis2();
    temp = fram1.read8(0xFA);
    temp += 1;
    fram1.write8(0xFA, temp);
    //sendSMS((char) 0xFA);
    break;

  //Sensor error illegal state
  case 3:
    LCDdis3();
    temp = fram1.read8(0xFB);
    temp += 1;
    fram1.write8(0xFB, temp);
    //sendSMS((char) 0xFB);
    break;

  //Power supply close-to-zero error
  case 4:
    LCDdis4();
    temp = fram1.read8(0xFC);
    temp += 1;
    fram1.write8(0xFC, temp);
    //sendSMS((char) 0xFC);
    break;

  //Power supply over amperage
  case 5:
    LCDdis5();
    temp = fram.read8(0xFD);
    temp += 1;
    fram1.write8(0xFD, temp);
    //sendSMS((char) 0xFD);
    break;

  //Clear state for whatever reason
  default:
    fram1.write8(0xF8, 0);
    fram1.write8(0xF9, 0);
    fram1.write8(0xFA, 0);
    fram1.write8(0xFB, 0);
    fram1.write8(0xFC, 0);
    fram1.write8(0xFD, 0);
    break;
    //sendSMS((char) a);
  }
}
//User presses this from main menu.
//Tells user the recorded errors, what alarms went off, and what to do.
void errorMSG(void)
{
  //Default state
  ReadA0 = 0;
  delay(1000);
  int Selectt = 1;
  LCDdis(ErrorMessage, "<-Alarm 0->", "Start up error", "number " +
        (String)fram1.read8(0xF8));
  //While main menu is not pressed
  while (ReadA0 != RM_AB)
  {
    Read_AB();
    correctA0();
    if (ReadA0 == RR_AB)
    {
      return;
    }
    if (ReadA0 == LL_AB)
    {
      Selectt -= 1;
    }
    if (ReadA0 == LM_AB)
    {
      Selectt += 1;
    }
    if (Selectt < 0)
    {
      Selectt = 8;
    }
    if (Selectt > 8)
    {
      Selectt = 1;
    }

    switch (Selectt)
    {
    case 1:
      LCDdis(ErrorMessage, "<-Alarm 0->", "Start up error", "number " +
            (String)fram1.read8(0xF8));
      break;
    case 2:
      LCDdis(ErrorMessage, "<-Alarm 1->", "Full Error", "number " +
            (String)fram1.read8(0xF9));
      break;
    case 3:
      LCDdis(ErrorMessage, "<-Alarm 2->", "Tank Empty", "number " +
            (String)fram1.read8(0xFA));
      break;
    case 4:
      LCDdis(ErrorMessage, "<-Alarm 3->", "Sensor Error", "number " +
            (String)fram1.read8(0xFB));
      break;
    case 5:
      LCDdis(ErrorMessage, "<-Alarm 4->", "Power Supply Low", "number " +
            (String)fram1.read8(0xFC));
      break;
    case 6:
      LCDdis(ErrorMessage, "<-Alarm 5->", "Power Supply High", "number " +
            (String)fram1.read8(0xFD));
      break;
    case 7:
      LCDdis(ErrorMessage, "<-       ->", "Send Errors", "To Aqua Research");
      break;
    case 8:
      LCDdis(ErrorMessage, "<-       ->", "Clear all Errors", "number " +
            (String)(fram1.read8(0xF8) + fram1.read8(0xF9) + fram1.read8(0xFA) +
            fram1.read8(0xFB) + fram1.read8(0xFC) + fram1.read8(0xFD)));
      break;
    default:
      Serial.println("error");
      break;
    }
  }
  switch (Selectt)
  {
  case 1:
    //Alarm 0 message
    LCDdis0();
    break;
  case 2:
    //Alarm 1 message
    LCDdis1();
    break;
  case 3:
    //Alarm 2 message
    LCDdis2();
    break;
  case 4:
    //Alarm 3 message
    LCDdis3();
    ReadA0 = 0;
    while (ReadA0 < 10)
    {
      Read_AB();
    }
    break;
  case 5:
    //Alarm 4 message
    LCDdis4();
    break;
  case 6:
    //Alarm 5 message
    LCDdis5();
    break;
  case 7:
    //sends alle rrrors to aqua research
    for (int i = 0xF8; i < 0xFE; i++)
    {
      if (fram1.read8(i) != 0)
      {
        delay(2);
        //sendSMS((char)i)
      }
    }
    delay(1);
    break;
  case 8:
    //clear all errors
    alarm(15);
    break;
  default:
    Serial.println("error");
    break;
  }
  return;
}

//Alarm 0 message.
void LCDdis0()
{
  lcd.setBacklight(100);
  lcd.home();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Start up Error");
  lcd.setCursor(0, 1);
  lcd.print("");
  lcd.setCursor(0, 2);
  lcd.print("");
  lcd.setCursor(0, 3);
  lcd.print("");
  delay(100);
  ReadA0 = 0;
  while (ReadA0 < 10)
  {
    Read_AB();
  }
}
//Alarm 1 message
void LCDdis1()
{
  lcd.setBacklight(100);
  lcd.home();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Empty Full Tank");
  lcd.setCursor(0, 1);
  lcd.print("Check Tank:");
  lcd.setCursor(0, 2);
  lcd.print("Brine, Oxidant, Or");
  lcd.setCursor(0, 3);
  lcd.print("Electrolyte Tanks");
  delay(100);
  ReadA0 = 0;
  while (ReadA0 < 10)
  {
    Read_AB();
  }
}
//Alarm 2 message
void LCDdis2()
{
  lcd.setBacklight(100);
  lcd.home();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Check for Empty Tank");
  lcd.setCursor(0, 1);
  lcd.print("Check Tank");
  lcd.setCursor(0, 2);
  lcd.print("Brine and");
  lcd.setCursor(0, 3);
  lcd.print("Electrolyte");
  delay(100);
  ReadA0 = 0;
  while (ReadA0 < 10)
  {
    Read_AB();
  }
}
//Alarm 3 message
void LCDdis3()
{
  lcd.setBacklight(100);
  lcd.home();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Senser Error");
  lcd.setCursor(0, 1);
  lcd.print("Check all Tank");
  lcd.setCursor(0, 2);
  lcd.print("Sensors");
  lcd.setCursor(0, 3);
  lcd.print("");
  delay(100);
  ReadA0 = 0;
  while (ReadA0 < 10)
  {
    Read_AB();
  }
}
//Alarm 4 message
void LCDdis4()
{
  lcd.setBacklight(100);
  lcd.home();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("No Current");
  lcd.setCursor(0, 1);
  lcd.print("From Power Supply");
  lcd.setCursor(0, 2);
  lcd.print("");
  lcd.setCursor(0, 3);
  lcd.print("");
  delay(100);
  ReadA0 = 0;
  while (ReadA0 < 10)
  {
    Read_AB();
  }
}
//Alarm 5 message
void LCDdis5()
{
  lcd.setBacklight(100);
  lcd.home();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Excess Current");
  lcd.setCursor(0, 1);
  lcd.print("Power Supply Too");
  lcd.setCursor(0, 2);
  lcd.print("Much Amperage");
  lcd.setCursor(0, 3);
  lcd.print("");
  delay(100);
  ReadA0 = 0;
  while (ReadA0 < 10)
  {
    Read_AB();
  }
}
/* When sim card is hooked up properly uncomment
//Set up for sms
void SendSMSsetup(void)
{
  SIM.begin(9600);
  delay(100);
  SIM.pinCode(GET);
  // WARNING! Be certain that you input the correct pin code!
  if (SIM.reply("SIM PIN")) SIM.pinCode(SET, code);
}
//Sends the SMS
void sendSMS(char error){
  SIM.smsFormat(SET, "1");
  SIM.smsSend(addr, error);
}
*/