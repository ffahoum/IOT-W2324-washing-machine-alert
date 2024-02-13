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

### const int threshold
- **Description:** Vibration detection threshold used to determine if vibration is detected.
- **Type:** Integer
- **Accessibility:** Private
- **Usage:** Defines the threshold value against which the magnitude of acceleration is compared to detect vibration.

### bool initialized
- **Description:** Flag indicating whether the sensor is initialized.
- **Type:** Boolean
- **Accessibility:** Private
- **Usage:** Indicates whether the sensor has been successfully initialized. Used to check if sensor data can be reliably read.

### sensors_vec_t gyro
- **Description:** Gyroscope data obtained from the sensor.
- **Type:** sensors_vec_t (struct)
- **Accessibility:** Private
- **Usage:** Stores the gyroscope data retrieved from the MPU6050 sensor.

### float temprature
- **Description:** Temperature data obtained from the sensor.
- **Type:** Float
- **Accessibility:** Private
- **Usage:** Stores the temperature data retrieved from the MPU6050 sensor.

### sensors_vec_t acceleration
- **Description:** Acceleration data obtained from the sensor.
- **Type:** sensors_vec_t (struct)
- **Accessibility:** Public
- **Usage:** Stores the acceleration data retrieved from the MPU6050 sensor.


## Methods

### VibrationSensor()
- **Description:** Constructor for the `VibrationSensor` class.
- **Parameters:** None
- **Usage:** Create an instance of the `VibrationSensor` class to interface with the MPU6050 sensor.

### update()
- **Description:** Updates the sensor readings by reading accelerometer, gyroscope, and temperature data from the MPU6050 sensor.
- **Parameters:** None
- **Returns:** True if the sensor is initialized and data is successfully updated, false otherwise.
- **Usage:** Call this method periodically to update sensor readings.

### isVibrating()
- **Description:** Checks if vibration is detected based on the sensor readings.
- **Parameters:** None
- **Returns:** True if vibration is detected, false otherwise.
- **Usage:** Call this method to determine if vibration is detected based on the current sensor readings.


## Vibration Threshold Finding Procedure

### Overview
This sesction outlines the procedure of finding a finetuning the vibration threshold used in the washing machine simulation project. The vibration threshold is a critical parameter that determines when the washing machine cycle has finished based on the intensity of vibrations detected by the accelerometer sensor.

### Procedure

#### Empirical Testing
Empirical testing is conducted to observe the vibration patterns generated during different stages of the washing machine cycle. This inclolves running the washing machine simulation with the vibration motor and accelerometer sensor in place and recording the accelerometer readings.
```cpp
#include <Arduino.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

const int VibrationPin = 23;
Adafruit_MPU6050 mpu;

void initializeMPU6050() {
  Serial.println("Adafruit MPU6050 test!");
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }
  Serial.println("MPU6050 Found!");
  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);
  Serial.println("");
  delay(100);
}

void controlVibration(bool state, int duration) {
  analogWrite(VibrationPin, state ? 255 : 0);
  Serial.println(state ? "Vibration On" : "Vibration Off");
  delay(duration);
}

void readMpuValue() {
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  Serial.print("Acceleration X: ");
  Serial.print(a.acceleration.x);
  Serial.print(", Y: ");
  Serial.print(a.acceleration.y);
  Serial.print(", Z: ");
  Serial.print(a.acceleration.z);
  Serial.println(" m/s^2");

  Serial.println("");
  delay(500);

}

void setup(void) {
  Serial.begin(9600);
  while (!Serial) {
    Serial.println("Failed to find MPU6050 chip");
    delay(10);
  }
  Serial.println("MPU6050 Found!");
  pinMode(VibrationPin, OUTPUT);
  initializeMPU6050();
}

void loop() {
  controlVibration(true, 1000);
  readMpuValue();
  controlVibration(false, 1000);
  readMpuValue();
}
```
### Threshold Adjustment and Iterative Fine-Tuning
Based on observations from the empicial testing, the threshold value is adjusted iteratively to find and optimal value that reliably distinguish between washing machine vabrations and background noise. Small adjustments are made to the threshold value, and the system is tested again to evaluate the effectiveness of each adjustment.

- **Option 1**: Uses the formula *`sqrt(X^2 + Y^2 + Z^2)`* to calculate the vibration intensity.
- **Option 2**: Uses the forumla *`|X| + |Y| + |Z|`* to calculate the vibration intensity.

| Iteration | Vibration Setting | Accelerometer Readings (X, Y, Z) | Option 1 | Option 2 | 
|-----------|-------------------|----------------------------------|----------|----------|
| 1         | On                | (-0.5, -0.09, 10.50)             | 10.512   |  11.09   |
| 2         | Off               | (-0.28, -0.10, 9.75)             | 9.754    |  10.13   |
| 3         | On                | (0.88, 0.09, 7.76)               | 7.810    |  8.73    |
| 4         | Off               | (-0.32, -0.11, 9.76)             | 9.765    |  10.19   |
| 5         | On                | (-1.64, -0.46, 12.38)            | 12.496   |  14.48   |
| 6         | Off               | (-0.37, -0.10, 9.75)             | 9.757    |  10.22   |
| 7         | On                | (-0.16, 0.32, 9.05)              | 9.057    |  9.53    |
| 8         | Off               | (-0.37, -0.11, 9.97)             | 9.977    |  10.45   |
| 9         | On                | (-0.57, 0.18, 10.20)             | 10.217   |  10.95   |
| 10        | Off               | (-0.34, -0.09, 9.78)             | 9.786    |  10.21   |
| 11        | On                | (-1.22, 0.11, 11.37)             | 11.435   |  12.7    |
| 12        | Off               | (-0.25, -0.13, 9.76)             | 9.764    |  10.14   |
| 13        | On                | (-0.98, -1.18, 12.38)            | 12.474   |  14.54   |
| 14        | Off               | (-0.23, -0.13, 9.74)             | 9.743    |  10.1    |
| 15        | On                | (-1.31, 0.45, 9.8)               | 9.897    |  11.56   |
| 16        | Off               | (-0.24, -0.15, 9.76)             | 9.764    |  10.15   |



### Insights
- **Consistency of Readings**: Some iterations show relatively consistent vibration intensity values over consecutive "Off" states.
- **Potential Outliers**: Iteration 3, 5 and 13 for Option 1 and Option 2 has notably higher vibration intensity values compared to other iterations. This could indicate a potential outlier in the data.

### Consideration of Tolerance
A tolerance margin of error is introduced to account for variations in vibration intensity due to factors like environmental conditions. This tolerance value helps ensure robustness and reliability in detecting the end of the washing machine cycle.

### Validation Testing
Validation testing is conducted to verify the effectiveness of the threshold in accurately detecting the end of the washing machine cycle under various conditions. The system is tested with different vibration motor intensities, cycle durations, and environmental conditions to validate its performance.
```cpp
#include <Arduino.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

const int VibrationPin = 23;
Adafruit_MPU6050 mpu;

float vibrationThreshold = 9.8; 

void initializeMPU6050() {
  Serial.println("Adafruit MPU6050 test!");

  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }

  Serial.println("MPU6050 Found!");

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  Serial.println("");
  delay(100);
}

bool isVibrationOn(sensors_event_t &a) {
  // Check if any acceleration component exceeds the threshold
  return 
  (sqrt(
    a.acceleration.x * a.acceleration.x + 
    a.acceleration.y * a.acceleration.y + 
    a.acceleration.z * a.acceleration.z) > vibrationThreshold
  );
}

void controlVibration(bool state, int duration) {
  analogWrite(VibrationPin, state ? 255 : 0);
  Serial.println(state ? "Vibration On" : "Vibration Off");
  delay(duration);
}

void readMpuValue() {
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  Serial.print("Acceleration X: ");
  Serial.print(a.acceleration.x);
  Serial.print(", Y: ");
  Serial.print(a.acceleration.y);
  Serial.print(", Z: ");
  Serial.print(a.acceleration.z);
  Serial.println(" m/s^2");


  // Check if vibration module should be on or off
  bool vibrationState = isVibrationOn(a);
  Serial.println(vibrationState ? "Detected Vibration On" : "Detected Vibration Off");

  Serial.println("");
  delay(500);
}

void setup(void) {
  Serial.begin(9600);
  while (!Serial) {
    Serial.println("Failed to find MPU6050 chip");
    delay(10);
  }
  Serial.println("MPU6050 Found!");
  pinMode(VibrationPin, OUTPUT);
  initializeMPU6050();
}

void loop() {
  controlVibration(true, 1000);
  readMpuValue();
  controlVibration(false, 1000);
  readMpuValue();
}
```
| Iteration | Vibration Setting | Detected |
|-----------|-------------------|----------|
| 1         | On                | On       |
| 2         | Off               | Off      |
| 3         | On                | On       |
| 4         | Off               | Off      |
| 5         | On                | On       |
| 6         | Off               | Off      |
| 7         | On                | Off      |



### Conclusion
To enhance the accuracy of vibration intensity detection, we propose a refinement to the process. Rather than solely relying on a single measurement, we suggest performing multiple consecutive measurements using the MPU6050 sensor. By averaging these measurements, we can mitigate the impact of outliers and reduce the likelihood of false-positive results.

The chosen threshold for vibration intensity is set at 9.8 units, serving as a reference point for determining whether the measured intensity exceeds the acceptable level. However, instead of making decisions based solely on individual readings, we recommend establishing a protocol where multiple consecutive readings are taken and averaged.

This approach offers several benefits:

- Outlier Mitigation: Averaging multiple readings helps to smooth out variations caused by outliers or transient disturbances.
- Improved Reliability: By considering a series of measurements, we gain more confidence in the accuracy of the reported vibration intensity.
- Reduced False Positives: Averaging reduces the likelihood of false-positive results, ensuring that genuine instances of elevated vibration intensity are correctly identified.

Refining the procedure in this manner enhances the robustness of the vibration intensity detection system, making it more reliable for practical applications.


## Considerations
- The vibration detection threshold is calculated based on considerations of sensor sensitivity and typical vibration intensities.
- The Euclidean distance metric (magnitude of acceleration vector) is used for vibration detection, providing a more accurate representation of acceleration magnitude in three-dimensional space.
- The MPU6050 sensor is configured with a range of 8G for the accelerometer and 500 degrees per second for the gyroscope to accommodate a wide range of vibration intensities.

## Example Usage
```cpp
#include "VibrationSensor.h"

VibrationSensor vibrationSensor;

void setup() {
    Serial.begin(9600);
    vibrationSensor.initialize();
}

void loop() {
    vibrationSensor.update(); // Update sensor readings
    bool vibrating = vibrationSensor.isVibrating();
    
    if (vibrating) {
        Serial.println("Vibrating detected!");
        // Take appropriate action, such as sending a notification
    }

    delay(1000); // Adjust delay as needed
}
