#include <Arduino.h>
#include "VibrationSensor.h"
#include <vector>

#define ZERO_VIBRATIONS_PEAK 12
#define LOW_VIBRATION_THRESHOLD 17
#define MEDIUM_VIBRATION_THRESHOLD 26
#define HIGH_VIBRATION_THRESHOLD 40
#define VALID_THRESHOLD_RANGE 3
#define LOW_VALID_INTENSITY 150
#define MEDIUM_VALID_INTENSITY 180
#define HIGH_VALID_INTENSITY 255

VibrationSensor::VibrationSensor() {
    if (mpu.begin()) {
        mpu.setAccelerometerRange(MPU6050_RANGE_2_G);
        mpu.setGyroRange(MPU6050_RANGE_500_DEG);
        mpu.setFilterBandwidth(MPU6050_BAND_260_HZ);
        initialized = true;
    }
    else {
        initialized = false;
    }
}

void VibrationSensor::update() {
    if (!initialized) {
        throw VibrationSensor::SensorNotInitializedException();
    }
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);
    xAcceleration = a.acceleration.x;
    yAcceleration = a.acceleration.y;
    zAcceleration = a.acceleration.z;
}

void VibrationSensor::updateVibrationPeaksArray() {
    if (!initialized) {
        throw VibrationSensor::SensorNotInitializedException();
    }
    digitalWrite(LED_BUILTIN, HIGH);  
    sensors_event_t a, g, temp;
    float readings[READINGS_NUM][3] = {0};
    float vibrations[READINGS_NUM] = {0};
    for (int i = 0; i < READINGS_NUM; i++) {
        mpu.getEvent(&a, &g, &temp);
        readings[i][0] = a.acceleration.x;
        readings[i][1] = a.acceleration.y;
        readings[i][2] = a.acceleration.z;
        vibrations[i] = calculateVibrationIntensity(a);
        delay(10);
    }

    for (int i = 0; i < READINGS_NUM / CHUNK_SIZE; i++) {
        float max = vibrations[i * CHUNK_SIZE];
        for (int j = 0; j < CHUNK_SIZE; j++) {
            if (vibrations[i * CHUNK_SIZE + j] > max) {
                max = vibrations[i * CHUNK_SIZE + j];
            }
        }
        maxPerChunk[i] = max;
    }
    digitalWrite(LED_BUILTIN, LOW);  
}

bool VibrationSensor::isVibrating() {
    int belowThreshold = 0;
    for (int i = 0; i < READINGS_NUM / CHUNK_SIZE; i++) {
        if(maxPerChunk[i] <= ZERO_VIBRATIONS_PEAK) {
            belowThreshold++;
        }
    }
    vibrating = !(belowThreshold >= READINGS_NUM / CHUNK_SIZE * 3 / 4);
    return vibrating;
}

bool VibrationSensor::isLowThresholdValid() {
    int outOfRange = 0;
    if (!vibrating) return true;
    for (int i = 0; i < READINGS_NUM / CHUNK_SIZE; i++) {
        if(maxPerChunk[i] > LOW_VIBRATION_THRESHOLD + VALID_THRESHOLD_RANGE) {
            outOfRange++;
        }
    }
    return !(outOfRange >= READINGS_NUM / CHUNK_SIZE * 3 / 4);
}

bool VibrationSensor::isMediumThresholdValid() {
    int outOfRange = 0;
    if (!vibrating) return true;
    for (int i = 0; i < READINGS_NUM / CHUNK_SIZE; i++) {
        if(maxPerChunk[i] > MEDIUM_VIBRATION_THRESHOLD + VALID_THRESHOLD_RANGE ||
            maxPerChunk[i] < MEDIUM_VIBRATION_THRESHOLD - VALID_THRESHOLD_RANGE) {
            outOfRange++;
        }
    }
    return !(outOfRange >= READINGS_NUM / CHUNK_SIZE * 3 / 4);
}

bool VibrationSensor::isHighThresholdValid() {
    int outOfRange = 0;
    if (!vibrating) return true;
    for (int i = 0; i < READINGS_NUM / CHUNK_SIZE; i++) {
        if(maxPerChunk[i] < HIGH_VIBRATION_THRESHOLD - VALID_THRESHOLD_RANGE) {
            outOfRange++;
        }
    }
    return !(outOfRange >= READINGS_NUM / CHUNK_SIZE * 3 / 4);
}

float VibrationSensor::calculateVibrationIntensity(sensors_event_t& a) {
    return abs(a.acceleration.x) +
        abs(a.acceleration.y) +
        abs(a.acceleration.z);
}
