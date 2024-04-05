#include <Arduino.h>
#include "VibrationSensor.h"
#include "WiFiController.h"
#include "FirebaseManager.h"
#include "MagnetSensor.h"
#include "time.h"
#include "Heartbeat.h"

using std::string;

#define MAGNET_SENSOR_PIN 32

VibrationSensor* mpu;
WiFiController* wifi;
FirebaseManager* firebase;
MagnetSensor* magnetSensor;
Heartbeat* heartbeatManager;
bool newMachineStatus;
bool newDoorStatus;
bool newLowValidityStatus;
bool newMediumValidityStatus;
bool newHighValidityStatus;

void setup(void) {
    Serial.begin(9600);
    pinMode(LED_BUILTIN, OUTPUT);

    wifi = new WiFiController();
    
    Serial.println();

    heartbeatManager = new Heartbeat();

    firebase = new FirebaseManager(heartbeatManager);
    firebase->establishConnection();
    
    mpu = new VibrationSensor();
    mpu->updateVibrationPeaksArray();
    newMachineStatus = mpu->isVibrating();
    newLowValidityStatus  = mpu->isLowThresholdValid();
    newMediumValidityStatus  = mpu->isMediumThresholdValid();
    newHighValidityStatus =  mpu->isHighThresholdValid();

    magnetSensor = new MagnetSensor(MAGNET_SENSOR_PIN);
    pinMode(MAGNET_SENSOR_PIN, INPUT);
    newDoorStatus = magnetSensor->isOpen();

    Serial.print("Washing machine status is ");
    Serial.println(newMachineStatus ? "On" : "Off");
    Serial.print("Door status is ");
    Serial.println(newDoorStatus ? "Open" : "Close");
    Serial.print("Low threshold intensity is ");
    Serial.println(newLowValidityStatus? "Valid" : "Invalid");
    Serial.print("Medium threshold intensity is ");
    Serial.println(newMediumValidityStatus? "Valid" : "Invalid");
    Serial.print("High threshold intensity is ");
    Serial.println(newHighValidityStatus? "Valid" : "Invalid");

    firebase->initDatabase(newDoorStatus, newMachineStatus, newLowValidityStatus, newMediumValidityStatus, newHighValidityStatus);
}

void loop() {

    wifi->Process();
    
    Serial.println("Updating timestamp in database...");
    firebase->updateTimeStamp();

    Serial.println();
    Serial.println("-----------------------------------");
    Serial.println("--- New Measeurements Iteration ---");
    Serial.println("-----------------------------------");

    Serial.println();    
    Serial.println("Measuring vibrations...");
    mpu->updateVibrationPeaksArray();
    newMachineStatus = mpu->isVibrating();
    Serial.println("Hang tight while we update the database accordingly...");
    Serial.print("Washing machine is: ");
    Serial.println(newMachineStatus? "ON" : "OFF");
    firebase->updateMachineStatus(newMachineStatus);

    Serial.println();
    Serial.println("-----------------------------------");
    Serial.println();

    Serial.println("Validating vibration intensity for low threshold...");
    newLowValidityStatus = mpu->isLowThresholdValid();
    Serial.println("Hang tight while we update the database accordingly...");
    Serial.print("Low threshold intensity is ");
    Serial.println(newLowValidityStatus? "valid" : "unvalid");
    firebase->updateThresholdStatus("low", newLowValidityStatus);


    Serial.println();
    Serial.println("-----------------------------------");
    Serial.println();

    Serial.println("Validating vibration intensity for medium threshold...");
    newMediumValidityStatus = mpu->isMediumThresholdValid();
    Serial.println("Hang tight while we update the database accordingly...");
    Serial.print("Medium threshold intensity is ");
    Serial.println(newMediumValidityStatus? "valid" : "unvalid");
    firebase->updateThresholdStatus("medium", newMediumValidityStatus);

    Serial.println();
    Serial.println("-----------------------------------");
    Serial.println();

    Serial.println("Validating vibration intensity for high threshold...");
    newHighValidityStatus = mpu->isHighThresholdValid();
    Serial.println("Hang tight while we update the database accordingly...");
    Serial.print("High threshold intensity is ");
    Serial.println(newHighValidityStatus? "valid" : "unvalid");
    firebase->updateThresholdStatus("high", newHighValidityStatus);


    Serial.println();
    Serial.println("-----------------------------------");
    Serial.println();   

    Serial.println("Reading magnet field intensity...");
    newDoorStatus = magnetSensor->isOpen();
    Serial.println("Hang tight while we update the database accordingly...");
    Serial.print("Washing machine door is: ");
    Serial.println(newDoorStatus ? "Open" : "Close");
    firebase->updateDoorStatus(newDoorStatus);

}
