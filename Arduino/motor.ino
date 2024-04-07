#include <Arduino.h>
#include <U8g2lib.h>
#include <SPI.h>
#include <Wire.h>

U8G2_SSD1306_128X32_UNIVISION_F_HW_I2C u8g2(U8G2_R0); 
const int motorPin = 9;

 void setup(void) {
  u8g2.begin();
  Serial.begin(9600);
  pinMode(motorPin, OUTPUT);   
}

void loop(void) {
  int sensorValue = analogRead(A0);
  analogWrite(motorPin, sensorValue / 4);
  u8g2.clearBuffer();	
  u8g2.setFont(u8g2_font_logisoso28_tr);  
  u8g2.drawStr(8,29,sensorValue / 4);	
  u8g2.sendBuffer();		
  delay(1);			
}
