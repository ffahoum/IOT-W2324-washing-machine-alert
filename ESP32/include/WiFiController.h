#ifndef WIFI_CONTROLLER_H
#define WIFI_CONTROLLER_H

#include <WiFiManager.h>

/**
 * @brief A class for managing WiFi connection using WiFiManager library.
 * 
 * This class provides functionality to handle WiFi connection using WiFiManager
 * library, which allows for easy configuration of WiFi credentials through
 * a web portal.
 */
class WiFiController {
public:
    /**
     * @brief Constructs a new WiFiController object.
     * 
     * This constructor initializes the WiFiManager object.
     */
    WiFiController();

    /**
     * @brief Process WiFi connection and configuration.
     * 
     * This function should be called in the main loop to handle
     * WiFi connection and configuration process.
     */
    void Process();


    void startConfigPortal();

private:
    WiFiManager wm; /**< WiFiManager object for handling WiFi connection and configuration. */
};

#endif
