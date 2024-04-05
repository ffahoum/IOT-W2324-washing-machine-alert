# WiFi Connection Test Documentation

## Test Name: test_wifi_connect

## Introduction
This documentation provides guidance on using the provided Arduino sketch to connect an ESP32 to a WiFi network. The sketch utilizes the `WiFi.h` library to establish a connection to a specified WiFi network using provided credentials.

## Purpose
The provided code snippet is intended to demonstrate how to connect an ESP32 microcontroller to a WiFi network using the Arduino IDE. It serves as a basic example for establishing a wireless connection, which is a common requirement for IoT (Internet of Things) and embedded projects.

## Setup
1. **Serial Communication**: Initializes serial communication at a baud rate of 115200 for debugging purposes.
2. **Delay**: Delays execution for 1 second (1000 milliseconds) to allow time for the serial monitor to initialize.
3. **WiFi Initialization**: Calls the `initWiFi()` function to initialize the WiFi connection.

## Main Loop
The main loop is left empty (`loop()` function), as the focus of this sketch is on the WiFi connection setup.

## `initWiFi()` Function
- **Network Credentials**: Replace `"REPLACE_WITH_YOUR_SSID"` and `"REPLACE_WITH_YOUR_PASSWORD"` with the SSID (WiFi network name) and password of the network you wish to connect to, respectively.
- **WiFi Mode**: Configures the ESP32 to operate in station mode (`WIFI_STA`) for connecting to an existing WiFi network.
- **Disconnect**: Disconnects from any previously connected network to ensure a clean connection attempt.
- **Delay**: Delays execution for 100 milliseconds to allow for proper disconnection.
- **Serial Output**: Prints "Setup done" to the serial monitor to indicate successful setup.
- **WiFi Connection**: Initiates the connection to the specified WiFi network using the provided credentials (`WiFi.begin(ssid, password)`).
- **Connection Status**: Enters a loop to wait for the ESP32 to establish a connection to the WiFi network. During this time, the sketch continuously prints dots ('.') to the serial monitor to indicate connection attempts.
- **Success Message**: Upon successful connection, prints the ESP32's assigned local IP address to the serial monitor.

## Usage
1. **Update Network Credentials**: Replace the placeholder SSID and password values with the credentials of your WiFi network.
2. **Upload Sketch**: Upload the modified sketch to your ESP32 board using the Arduino IDE or a compatible programming environment.
3. **Monitor Serial Output**: Open the serial monitor (baud rate: 115200) to view the status messages. Once connected, the assigned IP address will be displayed.

## Notes
- Ensure the correct SSID and password are provided to establish a successful connection.
- Verify that the ESP32 is within range of the target WiFi network.

## Dependencies
- This sketch requires the `WiFi.h` library, included by default in the ESP32 core for Arduino.
