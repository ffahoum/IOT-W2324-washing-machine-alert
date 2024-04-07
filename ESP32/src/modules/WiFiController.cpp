#include "WiFiController.h"

#define AP_SSID "EcoClean Pro"
#define AP_PASSWORD "qwerasdfzxcv1811"

WiFiController::WiFiController() {
  WiFi.mode(WIFI_STA);
  wm.resetSettings();
  wm.setConfigPortalBlocking(true);
  if(wm.autoConnect(AP_SSID, AP_PASSWORD)) {
    Serial.println("Connected");
    digitalWrite(LED_BUILTIN, LOW);     
  } else {
    digitalWrite(LED_BUILTIN, HIGH);  
    Serial.println("Configportal running");
  }
}

void WiFiController::Process() {
  wm.process();
}

void WiFiController::startConfigPortal() {
  wm.startConfigPortal();
  Serial.println("Connected to configuration portal. IP address: " + WiFi.localIP().toString());
}