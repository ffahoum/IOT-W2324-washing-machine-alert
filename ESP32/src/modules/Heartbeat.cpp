
#include <Arduino.h>
#include "Heartbeat.h"
#include "time.h"

Heartbeat::Heartbeat() {
  configTime(0, 0, ntpServer);
}

unsigned long Heartbeat::getTime() {
  time_t now;
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println("Failed to obtain time");
    return 0;
  }
  time(&now);
  return now;
}
