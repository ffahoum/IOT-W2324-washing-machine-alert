#include <Arduino.h>
#include "VibrationSensor.h"

VibrationSensor::VibrationSensor(float threshold) {
    if (mpu.begin()) {
        mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
        mpu.setGyroRange(MPU6050_RANGE_500_DEG);
        mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);
        initialized = true;
        this->threshold = threshold;
    }
    else {
        initialized = false;
    }
}

bool VibrationSensor::update() {
    if (!initialized) {
        return false;
    }
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);
    acceleration = a.acceleration;
    gyro = g.gyro;
    temprature = temp.temperature;
    return true;
}

bool VibrationSensor::isVibrating() {
    /* TODO: Handle if the MPU is not initialized */
    int vibrationIntensity = calculateVibrationIntensty();
    return vibrationIntensity > threshold;
}

float VibrationSensor::calculateVibrationIntensty() {
    /* TODO: Consider finetuning the forumla as needed */
    return sqrt(
        (acceleration.x * acceleration.x) +
        (acceleration.y * acceleration.y) +
        (acceleration.z * acceleration.z)
    );
}