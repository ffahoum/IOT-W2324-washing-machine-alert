#include <Arduino.h>
#include "VibrationSensor.h"
#include <vector>

#define READINGS_NUM 500
#define CHUNK_SIZE 10
#define ZERO_VIBRATIONS_PEAK 11

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

bool VibrationSensor::isVibrating() {
    if (!initialized) {
        throw VibrationSensor::SensorNotInitializedException();
    }
    sensors_event_t a, g, temp;
    float readings[READINGS_NUM][3] = {0};
    float vibrations[READINGS_NUM] = {0};
    for (int i = 0; i < READINGS_NUM; i++) {
        mpu.getEvent(&a, &g, &temp);
        readings[i][0] = a.acceleration.x;
        readings[i][1] = a.acceleration.y;
        readings[i][2] = a.acceleration.z;
        vibrations[i] = calculateVibrationIntensty(a);
        delay(10);
    }

    float maxPerChunk[READINGS_NUM / CHUNK_SIZE] = {0};
    for (int i = 0; i < READINGS_NUM / CHUNK_SIZE; i++) {
        float max = vibrations[i * CHUNK_SIZE];
        for (int j = 0; j < CHUNK_SIZE; j++) {
            if (vibrations[i * CHUNK_SIZE + j] > max) {
                max = vibrations[i * CHUNK_SIZE + j];
            }
        }
        maxPerChunk[i] = max;
    }

    int belowThreshold = 0;
    for (int i = 0; i < READINGS_NUM / CHUNK_SIZE; i++) {
        if(maxPerChunk[i] <= ZERO_VIBRATIONS_PEAK) {
            belowThreshold++;
        }
    }

    return !(belowThreshold >= READINGS_NUM / CHUNK_SIZE * 3 / 4);
}

float VibrationSensor::calculateVibrationIntensty(sensors_event_t& a) {
    return abs(a.acceleration.x) +
        abs(a.acceleration.y) +
        abs(a.acceleration.z);
}
