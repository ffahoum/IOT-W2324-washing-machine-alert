#include "WiFi.h"

void setup()
{
    Serial.begin(115200);
    delay(1000);
    initWiFi();
}

void loop() {

}

void initWiFi() {
    // Replace with your network credentials
    const char* ssid = "REPLACE_WITH_YOUR_SSID";
    const char* password = "REPLACE_WITH_YOUR_PASSWORD";
    WiFi.mode(WIFI_STA);
    WiFi.disconnect();
    delay(100);
    Serial.println("Setup done");
    WiFi.begin(ssid, password);
    Serial.print("Connecting to WiFi ..");
    while (WiFi.status() != WL_CONNECTED) {
    Serial.print('.');
    delay(1000);
    }
    Serial.println(WiFi.localIP());
}