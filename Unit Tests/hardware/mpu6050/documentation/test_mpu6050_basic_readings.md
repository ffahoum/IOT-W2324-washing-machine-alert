# MPU6050 Sensor Test Documentation

## Test Name: test_mpu6050_basic_readings

### Description
The MPU6050 Sesnsor Test demonstrates the functionality of the MPU6050 sensor by reading accelerometer, gyroscope, and temprature data. The test ensures that the sensor is properly initialized and provides accurate readings.

### Test Environment
- ESP32 DEVKIT1 microcontroller.
- MPU6050 sensor (ITG/MPU).
- USB cable for connecting ESP32 to a power source.
- Jumper wires.
- Stable, flat, surface.

### Connection
- Connect the MPU6050 sensor to the ESP32 microcontroller.
- Connect the ESP32 to a computer using a USB cable.
- Observe the readings of the accerolometer, gyroscope, and temprature.

### Test Steps
- Ensure proper connections of the MPU6050 sensor to the ESP32.
- Place the MPU6050 sensor on a stable, flat surface.
- Connect the ESP32 to your computer using a USB cable.
- Upload the test `test_mpu6050_basic_readings.ino` code to the ESP32.
- Open the Serial Monitor in the Arduino IDE.
- Observe the readings of accerolometer, gyroscope, and temperature.

### Expected Results
- The Serial Monitor should display stable readings for accelerometer (X, Y, Z), gyroscope (X, Y, Z), and temperature.
- Accelerometer readings (X, Y, Z) should indicate values close to 0 m/s^2 in the plane parallel to the surface.
- Due to the influence of gravity, the accelerometer reading in the Z-axis should be approximately equal to 9.8 m/s^2.
- Gyroscope readings (X, Y, Z) should indicate minimal rotational values, reflecting the absence of significant motion.
- The temperature reading should represent the ambient temperature.

### Test Status
- &#x2611; Passed.
- &#x2610; Failed.

### Test Date
- 2024-01-26