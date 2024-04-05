# VibrationSensor Documentation

## Overview
The `VibrationSensor` class provides an interface for interfacing with an MPU6050 accelerometer sensor to detect vibrations. This document provides details about the class, its methods, and considerations behind its implementation.

## Class Description
The `VibrationSensor` class encapsulates functionality related to initializing the MPU6050 sensor, updating sensor readings, and detecting vibrations based on acceleration data.

## Properties

### Adafruit_MPU6050 mpu
- **Description:** Instance of the MPU6050 class for interfacing with the accelerometer sensor.
- **Type:** Adafruit_MPU6050
- **Accessibility:** Private
- **Usage:** Used to initialize and interact with the MPU6050 accelerometer sensor.

### bool initialized
- **Description:** Flag indicating whether the sensor is initialized.
- **Type:** Boolean
- **Accessibility:** Private
- **Usage:** Indicates whether the sensor has been successfully initialized. Used to check if sensor data can be reliably read.

### float xAcceleration
- **Description:** X-axis acceleration obtained from the sensor.
- **Type:** Float
- **Accessibility:** Public
- **Usage:** Stores the X-axis acceleration data retrieved from the MPU6050 sensor.

### float yAcceleration
- **Description:** Y-axis acceleration obtained from the sensor.
- **Type:** Float
- **Accessibility:** Public
- **Usage:** Stores the Y-axis acceleration data retrieved from the MPU6050 sensor.

### float zAcceleration
- **Description:** Z-axis acceleration obtained from the sensor.
- **Type:** Float
- **Accessibility:** Public
- **Usage:** Stores the Z-axis acceleration data retrieved from the MPU6050 sensor.

### float maxPerChunk[READINGS_NUM / CHUNK_SIZE]
- **Description:** Array to store maximum readings per chunk.
- **Type:** Float array
- **Size:** READINGS_NUM / CHUNK_SIZE
- **Accessibility:** Private
- **Usage:** Used to store the maximum vibration peaks per chunk of readings.

### bool vibrating
- **Description:** Flag indicating if vibration is detected.
- **Type:** Boolean
- **Accessibility:** Private
- **Usage:** Used to indicate whether vibration is detected based on sensor readings.


## Methods

### VibrationSensor()
- **Description:** Constructor for the `VibrationSensor` class.
- **Parameters:** None
- **Usage:** Create an instance of the `VibrationSensor` class to interface with the MPU6050 sensor.

### update()
- **Description:** Updates the sensor readings by reading accelerometer data from the MPU6050 sensor.
- **Parameters:** None
- **Returns:** None
- **Usage:** Call this method periodically to update sensor readings.

### isVibrating()
- **Description:** Checks if vibration is detected based on the sensor readings.
- **Parameters:** None
- **Returns:** True if vibration is detected, false otherwise.
- **Usage:** Call this method to determine if vibration is detected based on the current sensor readings.

### calculateVibrationIntensity(sensors_event_t& a)
- **Description:** Calculate the vibration intensity based on accelerometer readings.
- **Parameters:** 
  - `a`: Reference to the accelerometer sensor event.
- **Returns:** The calculated vibration intensity as a floating-point value.
- **Usage:** Use this method to calculate the vibration intensity using the provided accelerometer readings according to a specific formula.

### updateVibrationPeaksArray()
- **Description:** Updates the array of vibration peaks based on sensor readings.
- **Parameters:** None
- **Returns:** None
- **Usage:** Call this method to read accelerometer data from the MPU6050 sensor, calculate vibration intensity for each reading, and update the array of maximum vibration peaks per chunk of readings.

### isLowThresholdValid()
- **Description:** Checks if the vibration intensity exceeds the low threshold.
- **Parameters:** None
- **Returns:** True if the vibration intensity is within the valid range, false otherwise.
- **Usage:** Call this method to check if the vibration intensity is within the valid range based on the low threshold.

### isMediumThresholdValid()
- **Description:** Checks if the vibration intensity exceeds the medium threshold.
- **Parameters:** None
- **Returns:** True if the vibration intensity is within the valid range, false otherwise.
- **Usage:** Call this method to check if the vibration intensity is within the valid range based on the medium threshold.

### isHighThresholdValid()
- **Description:** Checks if the vibration intensity exceeds the high threshold.
- **Parameters:** None
- **Returns:** True if the vibration intensity is within the valid range, false otherwise.
- **Usage:** Call this method to check if the vibration intensity is within the valid range based on the high threshold.

### SensorNotInitializedException
- **Description:** Exception class for handling cases where the sensor is not initialized.
- **Usage:** Thrown when attempting to perform operations on the sensor without proper initialization.

## Defines Documentation

### READINGS_NUM
- **Description:** Defines the total number of readings to be stored.
- **Type:** Integer
- **Value:** 1000
- **Usage:** Used to specify the size of arrays or buffers for storing sensor readings. 

### CHUNK_SIZE
- **Description:** Defines the size of each chunk for processing sensor readings.
- **Type:** Integer
- **Value:** 30
- **Usage:** Used to determine the number of readings processed together as a chunk for peak detection and analysis.

### LOW_THRESHOLD
- **Description:** Constant representing the low threshold for vibration intensity.
- **Type:** Float
- **Value:** 10.0
- **Usage:** Defines the minimum acceptable vibration intensity level considered as low vibration.

### MEDIUM_THRESHOLD
- **Description:** Constant representing the medium threshold for vibration intensity.
- **Type:** Float
- **Value:** 20.0
- **Usage:** Defines the threshold for medium vibration intensity, indicating a moderate level of vibration.

### HIGH_THRESHOLD
- **Description:** Constant representing the high threshold for vibration intensity.
- **Type:** Float
- **Value:** 30.0
- **Usage:** Defines the threshold for high vibration intensity, indicating a significant level of vibration.

### ZERO_VIBRATIONS_PEAK
- **Description:** Defines the peak value indicating zero vibrations.
- **Type:** Integer
- **Value:** 12
- **Usage:** Used as a threshold to determine zero vibrations based on the maximum vibration peak per chunk.
- **Insight:** This constant was determined through testing and fine-tuning the algorithm on various scenarios. It represents the baseline level of vibration intensity that can be considered as negligible. By setting this threshold appropriately, the algorithm can effectively differentiate between vibrations and background noise.

### LOW_VIBRATION_THRESHOLD
- **Description:** Defines the low threshold for vibration intensity.
- **Type:** Integer
- **Value:** 17
- **Usage:** Represents the threshold below which vibration intensity is considered low.
- **Insight:** Determining this threshold involved testing the algorithm with different vibration intensities and observing the range of values captured. Through iterative adjustments and analysis of sensor data, a threshold value was chosen that effectively distinguishes low-intensity vibrations from background noise.

### MEDIUM_VIBRATION_THRESHOLD
- **Description:** Defines the medium threshold for vibration intensity.
- **Type:** Integer
- **Value:** 26
- **Usage:** Represents the threshold for moderate vibration intensity.
- **Insight:** Similar to the low threshold, finding the medium threshold involved experimentation and fine-tuning. By analyzing sensor data across various vibration scenarios, a threshold value was selected that accurately categorizes moderate-intensity vibrations.

### HIGH_VIBRATION_THRESHOLD
- **Description:** Defines the high threshold for vibration intensity.
- **Type:** Integer
- **Value:** 40
- **Usage:** Represents the threshold for high vibration intensity.
- **Insight:** Defining the high threshold required thorough testing and analysis to ensure it captures significant vibration events while minimizing false positives. By testing the algorithm with high-intensity vibration scenarios, an appropriate threshold value was determined through iterative refinement.

### VALID_THRESHOLD_RANGE
- **Description:** Defines the valid threshold range.
- **Type:** Integer
- **Value:** 3
- **Usage:** Represents the range within which vibration intensity is considered valid.
- **Insight:** The determination of the valid threshold range was driven by the need to account for variations in vibration intensity measurements and sensor noise. By analyzing sensor data and observing the range of values recorded during different vibration events, a suitable range was defined to ensure the algorithm's robustness against noise and fluctuations.


### LOW_VALID_INTENSITY
- **Description:** Defines the low valid intensity threshold.
- **Type:** Integer
- **Value:** 160
- **Usage:** Represents the threshold below which vibration intensity is considered low valid.
- **Insight:** This threshold were established through iterative testing and adjustment of the algorithm to ensure that valid vibration intensities are accurately categorized within each intensity level. By analyzing sensor data and observing the distribution of vibration intensities, appropriate threshold values were chosen to validate the accuracy of vibration detection.


### MEDIUM_VALID_INTENSITY
- **Description:** Defines the medium valid intensity threshold.
- **Type:** Integer
- **Value:** 180
- **Usage:** Represents the threshold for moderate valid vibration intensity.
- **Insight:** This threshold were established through iterative testing and adjustment of the algorithm to ensure that valid vibration intensities are accurately categorized within each intensity level. By analyzing sensor data and observing the distribution of vibration intensities, appropriate threshold values were chosen to validate the accuracy of vibration detection.

### HIGH_VALID_INTENSITY
- **Description:** Defines the high valid intensity threshold.
- **Type:** Integer
- **Value:** 255
- **Usage:** Represents the threshold for high valid vibration intensity.
- **Insight:** This threshold were established through iterative testing and adjustment of the algorithm to ensure that valid vibration intensities are accurately categorized within each intensity level. By analyzing sensor data and observing the distribution of vibration intensities, appropriate threshold values were chosen to validate the accuracy of vibration detection.


## Vibration Detection Algorithm Explanation

### 1. Initialization
- The Vibration Sensor class initializes the MPU6050 sensor with specific configuration parameters in the constructor.
  - MPU6050 sensor is set to range 2G for accelerometer.
  - Gyroscope range is set to 500 degrees per second.
  - Filter bandwidth is set to 260 Hz.
- These initialization steps ensure that the sensor is configured appropriately for vibration measurement.

### 2. Reading Sensor Data
- The `update()` method reads accelerometer data from the MPU6050 sensor and updates the values of x, y, and z-axis accelerations.
- This step ensures that the latest sensor data is available for vibration analysis.

### 3. Calculation of Vibration Intensity
- The vibration intensity is calculated based on the accelerometer readings obtained from the sensor.
- The algorithm uses the formula `abs(x) + abs(y) + abs(z)` to calculate the magnitude of acceleration.
- This magnitude represents the overall vibration intensity irrespective of direction.

### 4. Update Vibration Peaks Array
- The `updateVibrationPeaksArray()` method updates the array of maximum vibration peaks per chunk of readings.
- It reads accelerometer data over a certain period and calculates the vibration intensity for each reading.
- The maximum vibration intensity for each chunk of readings is then stored in the array.
- This array helps in identifying significant changes in vibration intensity over time.
- By dividing the readings into chunks and processing a high number of readings, the algorithm aims to reduce noise and capture more accurate vibration patterns.

### 5. Vibration Detection
- The `isVibrating()` method determines whether vibration is detected based on the maximum vibration peaks per chunk.
- It counts the number of chunks where the maximum peak falls below the `ZERO_VIBRATIONS_PEAK` threshold.
- If more than 75% of the chunks have maximum peaks below the threshold, vibration is considered absent.
- Otherwise, vibration is detected.
- This mechanism ensures that vibration is consistently present across multiple readings for it to be considered as detected.

### 6. Threshold Validation
- Three thresholds are defined to categorize the vibration intensity: low, medium, and high.
- The thresholds are set as `LOW_VIBRATION_THRESHOLD`, `MEDIUM_VIBRATION_THRESHOLD`, and `HIGH_VIBRATION_THRESHOLD` respectively.
- Valid threshold ranges are defined around each threshold to allow for variations in vibration intensity.
- The algorithm checks if the maximum vibration peaks fall within these threshold ranges to determine the validity of vibration intensity.
- Peak-to-peak analysis is employed to consider variations in vibration intensity over time and avoid false positives or negatives.

### 7. Exception Handling
- The algorithm includes exception handling to handle cases where the sensor is not initialized properly.
- If the sensor initialization fails, a `SensorNotInitializedException` is thrown.
- This ensures robustness in handling unexpected conditions and errors during sensor operation.

### Motivation Behind Definitions
- The defined constants such as thresholds and ranges are motivated by the need to categorize and interpret vibration intensity levels.
- By defining specific thresholds, the algorithm can classify vibrations into different intensity levels: low, medium, and high.
- Valid threshold ranges allow for some tolerance in the vibration intensity measurements to account for variations and noise in the sensor readings.
- Using these defined constants provides flexibility and allows for easy adjustment of thresholds and ranges based on specific requirements and environmental conditions.