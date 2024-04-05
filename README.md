## Main Functionality Documentation

This document provides an overview of the main functionality of our project, detailing how various components interact and operate to achieve the desired functionality.

## Contents

1. [WiFi Controller Documentation](./docs/WiFiControllerDocumentation.md)
2. [Firebase Manager Documentation](./docs/FirebaseManagerDocumentation.md)
3. [Vibration Sensor Documentation](./docs/VibrationSensorDocumentation.md)
4. [Magnet Sensor Documentation](./docs/MagnetSensorDocumentation.md)
5. [Heartbeat Documentation](./docs/HeartBeatDocumentation.md)

### Description
The main functionality of the application involves initializing various sensors, establishing a connection to the WiFi network, and updating sensor data to the Firebase database periodically. The application monitors the vibration intensity of a washing machine using an accelerometer sensor (VibrationSensor), detects the status of the washing machine door using a magnetic sensor (MagnetSensor), and updates the sensor data to the Firebase database using the FirebaseManager.

### Initialization
1. **Serial Communication Setup:** Serial communication is initiated with a baud rate of 9600 for debugging purposes.
2. **LED Configuration:** The built-in LED (LED_BUILTIN) is configured as an output pin to provide visual indication during sensor readings and WiFi connection.
3. **WiFi Connection Setup:** The WiFiController object is initialized to manage WiFi connection using the WiFiManager library. The WiFiManager provides a web-based configuration portal for easy setup of WiFi credentials.
4. **Heartbeat Manager Initialization:** The Heartbeat object is created to obtain the current time from an NTP server. This time is used for timestamp updates in the Firebase database.
5. **Firebase Connection Establishment:** The FirebaseManager object is initialized with the Heartbeat manager to establish a connection to the Firebase database. The connection process involves signing up with Firebase using authentication credentials and configuring the Firebase database URL.
6. **Sensor Initialization:** 
   - The VibrationSensor object (mpu) is created to monitor vibration intensity using an accelerometer sensor. 
   - The MagnetSensor object (magnetSensor) is instantiated to detect the status of the washing machine door using a magnetic sensor.

### Sensor Data Update
1. **Initial Sensor Readings:**
   - The VibrationSensor (mpu) reads the vibration intensity and updates the database with initial status values.
   - The MagnetSensor (magnetSensor) detects the door status and updates the database with the initial door state.
2. **Periodic Sensor Updates:**
   - The loop function continuously monitors and updates sensor data to the Firebase database in each iteration.
   - Vibration intensity readings are updated periodically using the VibrationSensor (mpu) object.
   - Door status is monitored periodically using the MagnetSensor (magnetSensor) object.
   - Timestamp updates are performed using the Heartbeat manager as an integral part of the heartbeat errors detection mechanism.
3. **Database Update Procedures:**
   - Machine status updates are sent to the Firebase database based on vibration intensity readings.
   - Door status updates are sent to the Firebase database based on magnetic sensor readings.
   - Threshold validity status updates are performed to indicate the validity of vibration intensity thresholds (low, medium, high).

### WiFi Connection Management
1. **WiFi Connection Process:**
   - The WiFiController (wifi) object manages the WiFi connection process using the WiFiManager library.
   - The WiFiManager library facilitates easy configuration of WiFi credentials through a web-based portal.
   - The application periodically checks for WiFi connection status and handles configuration if not connected.

### Visual Indication
- Visual indication of the application state is provided using the built-in LED:
  - The LED blinks during sensor readings and database updates to indicate ongoing operations.
  - LED state changes provide visual feedback on the status of WiFi connection and sensor data updates.

### Error Handling
- The application handles errors gracefully by retrying WiFi connection and database updates.
- If the maximum retry attempt is reached, the application enters configuration mode to allow manual setup of WiFi credentials through the web portal.
