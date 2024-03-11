#include <Arduino.h>
#include "VibrationSensor.h"
#include "WiFiManager.h"
#include "FirebaseManager.h"
#include "MagnetSensor.h"

#define DATABASE_URL "https://wash-watch-default-rtdb.firebaseio.com/"
#define API_KEY "AIzaSyDBaDc85VryAXFR574PeZaoPaQe-OAUnMQ"
#define WIFI_SSID "ICST"
#define WIFI_PASSWORD "arduino123"
//#define WIFI_SSID "HOTBOX 4-44C8"
//#define WIFI_PASSWORD "DZJLTFKJUJ65"
#define MAGNET_SENSOR_PIN 32

using std::string;
VibrationSensor* mpu;
WiFiManager* wifi;
FirebaseManager* firebase;
MagnetSensor* magnetSensor;
bool newMachineStatus;
bool currentMachineStatus;
bool currentDoorStatus;
bool newDoorStatus;

void setup(void) {
    Serial.begin(9600);

    wifi = new WiFiManager(WIFI_SSID, WIFI_PASSWORD);
    wifi->establishConnection();

    Serial.println();

    firebase = new FirebaseManager(API_KEY, DATABASE_URL);
    firebase->establishConnection();

    mpu = new VibrationSensor();
    newMachineStatus = currentMachineStatus = mpu->isVibrating();

    magnetSensor = new MagnetSensor(MAGNET_SENSOR_PIN);
    pinMode(MAGNET_SENSOR_PIN, INPUT);
    newDoorStatus = currentDoorStatus = magnetSensor->isOpen();

    Serial.print("Washing machine is ");
    Serial.println(currentMachineStatus ? "On" : "Off");
    Serial.print("Door is ");
    Serial.println(currentDoorStatus ? "Open" : "Close");
    firebase->initDatabase(currentDoorStatus, currentMachineStatus);
}

void loop() {
    Serial.println("Measuring vibrations...");
    newMachineStatus = mpu->isVibrating();
    if (newMachineStatus != currentMachineStatus) {
        Serial.println("Hang tight while we update the database accordingly...");
        Serial.print("Washing machine was: ");
        Serial.println(currentMachineStatus ? "ON" : "OFF");
        Serial.print("Now it is: ");
        Serial.println(newMachineStatus? "ON" : "OFF");
        firebase->updateStatus(newMachineStatus);
    } else {
        Serial.println("Washing machine status has not changed.");
    }
    currentMachineStatus = newMachineStatus; 
    Serial.println("Reading magnet field intensity...");
    newDoorStatus = magnetSensor->isOpen();
    if (newDoorStatus != currentDoorStatus) {
        Serial.println("Hang tight while we update the database accordingly...");
        Serial.print("Washing machine door was: ");
        Serial.println(currentDoorStatus ? "Open" : "Close");
        Serial.print("Now it is: ");
        Serial.println(newDoorStatus ? "Open" : "Close");
        firebase->updateDoorStatus(newDoorStatus);
    } else {
        Serial.println("Washing machine door status has not changed.");
    }
    currentDoorStatus = newDoorStatus; 
}
