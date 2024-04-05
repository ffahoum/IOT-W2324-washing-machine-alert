#include <Arduino.h>
#include "MagnetSensor.h"

#define READINGS_NUM 100 /**< Number of readings for sensor calibration. */
#define DOOR_CLOSED_THRESHOLD 4095 /**< Threshold value for determining if the door is closed. */

MagnetSensor::MagnetSensor(int sensorPin) : sensorPin(sensorPin) {}

bool MagnetSensor::isOpen() {
    float readings[READINGS_NUM] = {0}; /**< Array to store sensor readings. */
    
    // Perform multiple readings to calibrate the sensor
    for (int i = 0; i < READINGS_NUM; i++) {
        readings[i] = analogRead(sensorPin);
        delay(10); // Delay between readings
    }
    
    int belowThreshold = 0; /**< Counter for readings below threshold. */
    
    // Count readings below the door closed threshold
    for (int i = 0; i < READINGS_NUM; i++) {
        if(readings[i] < DOOR_CLOSED_THRESHOLD) {
            belowThreshold++;
        }
    }
    
    // Determine if the majority of readings indicate an open state
    return (belowThreshold >= READINGS_NUM * 3 / 4);
}
