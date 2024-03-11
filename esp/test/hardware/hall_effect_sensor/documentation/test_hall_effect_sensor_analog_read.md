# Hall Effect Sensor Analog Read Test Documentation

## Test Name: test_esp32_blink

### Description
This document outlines the procedure for testing the basic functionality of a Hall Effect magnetic sensor with an ESP32 microcontroller. The test involves checking whether the sensor can detect the presence of a magnetic field.

### Test Environment
- ESP32 DEVKITV1 microcontroller.
- Hall Effect magnetic sensor with 3 pins (keyes).
- Jumper wires.
- Magnet.

### Connection
- Connect the sensor VCC to ESP Vin (5V).
- Connect the sensor GND to ESP32 GND.
- Connect OUT to ESP32 D13.

### Test Steps
- Connect the Hall effect sensor to the ESP32 as described in the "Connection" section.
- Ensure the ESP32 is properly powered.
- Upload the `test_hall_effect_sensor_analog_read.ino` code to the ESP32.
- Open the Serial Monitor.
- Observe the analog values printed to the Serial Monitor with no magnet nearby.
- Bring a magnet close to the Hall effect sensor during the test.

### Expected Results
- Without a Magnet:
    * The Serial Monitor should continously display analog values read from the Hall effect sensor.
    * THe analog values may vary based on any ambient magnetic fields but should generally remain stable.
- With a Magnet:
    * As the magnet is brought close to the Hall effect sensor, observe changes in the analog values displayed on the Serial Monitor.
    * The analog value may increase or decrease based on the strength and polarity of the magnetic field.
    * Note any patterns in the analog values as the magnet is moved closer of farther away.

### Test Observations
- **12:02:39.336:** Sensor Value: 3430
- **12:02:39.834:** Sensor Value: 3431
- **12:02:40.335:** Sensor Value: 3434
- **12:02:40.836:** Sensor Value: 3441
- **12:02:41.327:** Sensor Value: 4095
- **12:02:41.828:** Sensor Value: 4095
- **12:02:42.341:** Sensor Value: 4095
- **12:02:42.847:** Sensor Value: 4095
- **12:02:43.334:** Sensor Value: 4095
- **12:02:43.834:** Sensor Value: 4095

### Test Analysis
- The sensor values were observed at different timestamps during the test. The values indicate a transition from lower values (3430, 3431, 3434) to the maximum possible value (4095). The consistent reading of 4095 suggests that the sensor is detecting a strong magnetic field, as expected.

### Test Status
- &#x2611; Passed for both magnets.
- &#x2610; Failed.

### Test Date
- 2024-01-29