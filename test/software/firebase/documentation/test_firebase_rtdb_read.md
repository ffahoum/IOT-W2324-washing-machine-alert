# ESP32/ESP8266 Firebase Realtime Database Read Test Documentation

## Overview
This documentation provides guidance on setting up and running a test script for reading data from Firebase Realtime Database (RTDB) using an ESP32 microcontroller.

## Introduction
The provided Arduino sketch allows you to connect an ESP32 device to Firebase RTDB and read integer and float values from specified paths in the database.

## Prerequisites
- An ESP32 microcontroller.
- Access to a WiFi network.
- A Firebase project with RTDB enabled.
- Network credentials (SSID and password) for your WiFi network.
- Firebase project API Key.
- Firebase RTDB URL.

## Setup
1. **Include Firebase_ESP_Client Library**:
   - Make sure you have installed the Firebase_ESP_Client library in your Arduino IDE. You can find the library at: [Firebase_ESP_Client](https://github.com/mobizt/Firebase-ESP-Client).

2. **Insert Network Credentials and Firebase Configuration**:
   - Replace the placeholder values in the sketch with your WiFi network credentials (`WIFI_SSID` and `WIFI_PASSWORD`), Firebase project API Key (`API_KEY`), and Firebase RTDB URL (`DATABASE_URL`).

3. **Upload Sketch**:
   - Upload the modified sketch to your ESP32 or ESP8266 board using the Arduino IDE or compatible programming environment.

## Usage
1. **Monitor Serial Output**:
   - Open the serial monitor in the Arduino IDE (baud rate: 115200) to monitor the output.
   - The sketch will attempt to connect to the WiFi network and Firebase RTDB. Progress and errors will be printed to the serial monitor.

2. **Interact with Firebase RTDB**:
   - Once connected, the sketch will periodically read integer and float values from the specified paths in the RTDB.
   - The read values will be printed to the serial monitor.

3. **Verify Results**:
   - Verify that the integer and float values are successfully read from the specified paths in the Firebase RTDB.
   - Check for any errors or failure messages in the serial monitor.

## Notes
- Ensure that your ESP32 device is within range of the WiFi network and has access to the internet.
