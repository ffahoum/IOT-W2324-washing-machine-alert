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

#define READINGS_NUM 1000
#define CHUNK_SIZE 30

/**
 * @file VibrationSensor.h
 * @brief Header file for the VibrationSensor class.
 */

/**
 * @class VibrationSensor
 * @brief Class to interface with an MPU6050 accelerometer for vibration measurement and detection.
 */
class VibrationSensor {
    private:
    Adafruit_MPU6050 mpu;        /**< Instance of the MPU6050 class */
    bool initialized = false;        /**< Flag indicating if the sensor is initialized */
    float maxPerChunk[READINGS_NUM / CHUNK_SIZE] = {0}; /**< Array to store maximum readings per chunk */
    bool vibrating; /**< Flag indicating if vibration is detected */
    
    public:
    float xAcceleration;         /**< X-axis acceleration */
    float yAcceleration;         /**< Y-axis acceleration */
    float zAcceleration;         /**< Z-axis acceleration */

    /**
     * @brief Constructor for the VibrationSensor class.
     * Initializes the MPU6050 and sets its configuration prameters.
    */
    VibrationSensor();

    /**
     * @brief Updates the sensor readings.
     * Reads the accelerometer, gyroscope, and temperature data from the MPU6050 sensor.
     */
    void update();

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
     * @param a Reference to the accelerometer sensor event.
     * @return The calculated vibration intensity as a floating-point value.
     */
    float calculateVibrationIntensity(sensors_event_t& a);

    /**
     * @brief Updates the array of vibration peaks based on sensor readings.
     * 
     * This function reads accelerometer data from the MPU6050 sensor and calculates
     * vibration intensity for each reading. It then updates the array of maximum
     * vibration peaks per chunk of readings.
     * 
     * @throws SensorNotInitializedException if the sensor is not initialized.
     */
    void updateVibrationPeaksArray();

    /**
     * @brief Checks if the vibration intensity exceeds the low threshold.
     * @return True if the vibration intensity is within the valid range, false otherwise.
     */    
    bool isLowThresholdValid();

    /**
     * @brief Checks if the vibration intensity exceeds the medium threshold.
     * @return True if the vibration intensity is within the valid range, false otherwise.
     */    
    bool isMediumThresholdValid();

    /**
     * @brief Checks if the vibration intensity exceeds the high threshold.
     * @return True if the vibration intensity is within the valid range, false otherwise.
     */    
    bool isHighThresholdValid();

    class SensorNotInitializedException : public std::exception {};
};

#endif 