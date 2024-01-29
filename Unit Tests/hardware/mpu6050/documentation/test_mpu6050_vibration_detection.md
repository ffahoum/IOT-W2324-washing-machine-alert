# MPU6050 with Vibration Detection Test Dpcumentation

## Test Name: test_mpu6050_vibration_detection

### Description
The MPU6050 with Vibration Detection Test assesses the integration of an MPU6050 sensor with a vibration detection mechanism. The goal is to ensure the proper functionality of the MPU6050 in measuring acceleration, rotation, and temperature, with additional features to detect and report vibration events based on a specified threshold.

### Test Environment
- ESP32 DEVKIT1 microcontroller.
- MPU6050 sensor (ITG/MPU).
- Vibration module.
- Jumper wires.

### Connection
- Connect the MPU6050 sensor to the ESP32 microcontroller using the I2C interface.
- Connect the vibration module to a digital pin (`VibrationPin`) on the Arduino.

### Test Steps
1. Ensure proper connections of the MPU6050 sensor and the vibration detection setup to the ESP32.
2. Open the Arduino IDE and upload the `test_mpu6050_vibration_detection.ino` code to the ESP32 microcontroller.
3. Open the Serial Monitor to observe the output.

### Expected Results
- The MPU6050 initializes successfully, displaying configured ranges and bandwidths.
- Sensor values, including acceleration, rotation, and temperature, are printed on the Serial Monitor.
- The vibration module is activated for 1 second.
- The Serial Monitor also reports whether a vibration event is detected or not which is when the acceleration component exceeds the threshold.


#### Additional Considerations:
- Fine-tune the threshold value to ensure correct vibration detection.
- Review the Serial Monitor output for consistency and responsiveness of the vibration module.


### Test Results
1. **Vibration On**
    - Timestamp: 23:14:58.625
    - Serial Monitor Output:
        ```
        Vibration On
        Acceleration X: -1.11, Y: -0.24, Z: 8.48 m/s^2
        Rotation X: -0.05, Y: -0.14, Z: -0.02 rad/s
        Temperature: 21.21 degC
        Detected Vibration On
        ```
    
2. **Vibration Off**
    - Timestamp: 23:15:00.204
    - Serial Monitor Output:
        ```
        Vibration Off
        Acceleration X: 0.47, Y: -0.23, Z: 9.71 m/s^2
        Rotation X: -0.06, Y: -0.02, Z: -0.02 rad/s
        Temperature: 21.24 degC
        Detected Vibration Off
        ```
    
3. **Vibration On**
    - Timestamp: 23:15:01.796
    - Serial Monitor Output:
        ```
        Vibration On
        Acceleration X: -1.52, Y: -0.32, Z: 16.09 m/s^2
        Rotation X: -0.05, Y: -0.19, Z: -0.00 rad/s
        Temperature: 21.26 degC
        Detected Vibration On
        ```
    
4. **Vibration Off**
    - Timestamp: 23:15:03.380
    - Serial Monitor Output:
        ```
        Vibration Off
        Acceleration X: 0.50, Y: -0.23, Z: 9.78 m/s^2
        Rotation X: -0.06, Y: -0.00, Z: -0.02 rad/s
        Temperature: 21.27 degC
        ```

...


### Test Date
- 2024-01-23
