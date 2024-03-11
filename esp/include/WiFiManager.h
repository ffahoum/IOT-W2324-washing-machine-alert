#ifndef WiFiManager_H
#define WiFiManager_H

#include <WiFi.h>


class WiFiManager {
    public:
    WiFiManager(const char* ssid, const char* password);
    void establishConnection();

    private:
    const char* ssid;
    const char* password;
};

#endif
