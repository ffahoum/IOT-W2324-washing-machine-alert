## WiFiController Documentation

### Description
The WiFiController class provides functionality to manage WiFi connection and configuration using the WiFiManager library. It facilitates easy setup and configuration of WiFi credentials through a web portal, ensuring seamless integration of WiFi connectivity into the application.

### Properties

#### WiFiManager wm
- **Description:** WiFiManager object for handling WiFi connection and configuration.
- **Type:** WiFiManager
- **Accessibility:** Private

### Methods

#### WiFiController()
- **Description:** Constructor for the WiFiController class.
- **Usage:** Initializes the WiFiManager object and configures WiFi mode.

#### void Process()
- **Description:** Process WiFi connection and configuration.
- **Usage:** Call this method in the main loop to handle WiFi connection and configuration process.

#### void startConfigPortal()
- **Description:** Initiates the WiFi configuration portal.
- **Usage:** Call this method to start the WiFi configuration portal for user input of WiFi credentials.

### Usage
The WiFiController class is used to manage WiFi connection and configuration seamlessly using the WiFiManager library. It provides an intuitive interface for handling WiFi setup and allows for easy integration of WiFi functionality into the application.

### Considerations
- **WiFi Timeout:** The `WIFI_TIMEOUT_SEC` constant defines the timeout duration for WiFi connection attempts. Adjust the timeout value based on network conditions and application requirements to ensure timely connection establishment.
- **Access Point Credentials:** The `AP_SSID` and `AP_PASSWORD` constants specify the credentials for the WiFi access point (AP) mode used during configuration. Modify these values to customize the access point settings as needed.
- **LED Indication:** The built-in LED (LED_BUILTIN) is utilized for visual indication of WiFi connection status. The LED is turned off when connected and turned on when the configuration portal is active. Ensure proper LED connectivity and functionality for accurate status indication.
