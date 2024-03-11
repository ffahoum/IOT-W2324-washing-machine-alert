#include <Arduino.h>
#include "MagnetSensor.h"

#define READINGS_NUM 100
#define DOOR_CLOSED_THRESHOLD 4095
MagnetSensor::MagnetSensor(int sensorPin) : sensorPin(sensorPin) {}

bool MagnetSensor::isOpen() {
    float readings[READINGS_NUM] = {0};
    for (int i = 0; i < READINGS_NUM; i++) {
        readings[i] = analogRead(sensorPin);
        delay(10);
    }
    int belowThreshold = 0;
    for (int i = 0; i < READINGS_NUM; i++) {
        if(readings[i] < DOOR_CLOSED_THRESHOLD) {
            belowThreshold++;
        }
    }
    return (belowThreshold >= READINGS_NUM * 3 / 4);
}