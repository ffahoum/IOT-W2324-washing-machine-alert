/* VIBRATION_SENSOR_H */

/**
 * @file VibrationSensor.h
 * @brief Header file for the VibrationSensor class. 
*/
#ifndef VIBRATION_SENSOR_H
#define VIBRATION_SENSOR_H

#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_MPU6050.h>


/**
 * @class VibrationSensor
 * @brief Class to interface with an MPU6050 accelermometer for vibration measurment and detection.
*/
class VibrationSensor {
    private:
    Adafruit_MPU6050 mpu;       /**< Instance of the MPU6050 class */
    float threshold;         /**< Vibration detection threshold */
    bool initialized = false;       /**< Flag indicating if the sensor is initialized */
    sensors_vec_t gyro;     /**< Gyroscope data */
    float temprature;       /**< Temperature data */

    public:
    sensors_vec_t acceleration;     /**< Acceleration data */



    /**
     * @brief Constructor for the VibrationSensor class.
     * Initializes the MPU6050 and sets its configuration prameters.
    */
    VibrationSensor(float threshold);

    /**
     * @brief Updates the sensor readings.
     * Reads the accelerometer, gyroscope, and temperature data from the MPU6050 sensor.
     * @return True if the sensor is initialized and data is successfully updated, false otherwise.
     */
    bool update();

    /**
     * @brief Checks if vibration is detected based on the sensor readings.
     * Calculates the magnitude of acceleration and compares it against a predefined threshold.
     * @return True if vibration is detected, false otherwise.
     */
    bool isVibrating();

    /**
     * @brief Calculate the vibration intensity based on accelerometer readings.
     * 
     * This function calculates the vibration intensity using the provided accelerometer
     * readings according to a specific formula.
     * 
     * @return The calculated vibration intensity as a floating-point value.
     */
    float calculateVibrationIntensty();
};

#endif 