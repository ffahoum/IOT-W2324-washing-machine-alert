#include "WiFiManager.h"

WiFiManager::WiFiManager(const char* ssid, const char* password) :
ssid(ssid), password(password) { }

void WiFiManager::establishConnection() {
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("Establishing connection with WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("ESP connected to WiFi successfully");
}

