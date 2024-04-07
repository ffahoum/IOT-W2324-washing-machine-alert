# ESP32 WiFi Scan Test Documentation

## Test Name: test_wifi_scan

## Introduction
This documentation provides an overview of a sketch designed for the ESP32 microcontroller to scan for available WiFi networks. The sketch utilizes the Arduino IDE and the `WiFi.h` library to interface with the ESP32's WiFi capabilities.

## Setup
- Serial communication is initialized at a baud rate of 115200.
- The ESP32 is configured to operate in station mode (`WIFI_STA`) and disconnects from any previously connected access point (AP).

## Main Loop
- Continuously performs WiFi scans at regular intervals.
- Upon initiating a scan, it prints "Scan start" to the serial monitor.
- Calls the `WiFi.scanNetworks()` function to obtain the number of WiFi networks found.
- If no networks are found (`n == 0`), it prints "no networks found".
- If networks are found, it prints the number of networks found, followed by a table header for the network details (SSID, RSSI, Channel, Encryption).
- Iterates through each network found and prints its details, including SSID, RSSI, Channel, and Encryption type.
- The encryption type is determined using a switch-case statement based on the value returned by `WiFi.encryptionType(i)`.
- Deletes the scan results to free up memory.
- Waits for 5 seconds before initiating the next scan.

## Network Details
- **Nr**: Network number in the list of scanned networks.
- **SSID**: Service Set Identifier, the name of the WiFi network.
- **RSSI**: Received Signal Strength Indication, a measure of the received signal power.
- **CH**: Channel on which the network is operating.
- **Encryption**: Encryption type used by the network (Open, WEP, WPA, WPA2, WPA+WPA2, WPA2-EAP, WPA3, WPA2+WPA3, WAPI, unknown).

## Results
The following are the results obtained from a sample scan:
```
Scan done
4 networks found
Nr | SSID | RSSI | CH | Encryption
1  | HOTBOX 4-44C8 | -72 | 6 | WPA+WPA2
2  | Eitan & Yohai the kings | -79 | 1 | WPA+WPA2
3  | Heder30 | -91 | 11 | WPA+WPA2
4  | 459-26  | -94 | 1 | WPA+WPA2
```

## Usage
- Upload the provided sketch to an ESP32 board using the Arduino IDE.
- Open the serial monitor (baud rate: 115200) to view the scanned WiFi networks.
- Ensure the ESP32 is properly connected to a power source and has access to WiFi networks during testing.
- Adjust the delay between scans (`delay(5000)`) as needed to control the scanning frequency.

## Dependencies
- This sketch requires the `WiFi.h` library, included by default in the ESP32 core for Arduino.
