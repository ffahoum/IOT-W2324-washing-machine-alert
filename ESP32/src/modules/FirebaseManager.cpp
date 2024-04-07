#include "FirebaseManager.h"

#define DATABASE_URL "https://wash-watch-default-rtdb.firebaseio.com/"
#define API_KEY "AIzaSyDBaDc85VryAXFR574PeZaoPaQe-OAUnMQ"
#define WASHING_MACHINE_ID "eco_clean_pro"
#define RETRY_COUNT 600

FirebaseManager::FirebaseManager(Heartbeat* heartbeatManager) :
statusPath("washing_machines/" + std::string(WASHING_MACHINE_ID) + "/status"),
doorStatusPath("washing_machines/" + std::string(WASHING_MACHINE_ID) + "/door_open"),
thresholdsPath("washing_machines/" + std::string(WASHING_MACHINE_ID) + "/thresholds/"),
timestampPath("washing_machines/" + std::string(WASHING_MACHINE_ID) + "/timestamp") {
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  heartbeatManager = heartbeatManager;
}

void FirebaseManager::establishConnection() {
    Serial.println("Establishing connection with Firebase Database.");
    Serial.println("Trying to connect to firebase...");
    while (!Firebase.signUp(&config, &auth, "", "")) {
        digitalWrite(LED_BUILTIN, HIGH);  
        delay(100);
        digitalWrite(LED_BUILTIN, LOW);  
        delay(100); 
    }
    Firebase.begin(&config, &auth);
    Firebase.reconnectNetwork(true);
    Serial.println("Established connection with Firebase Database.");
}

bool FirebaseManager::updateMachineStatus(bool newStatus) {
    int retryCount = 0;
    bool writeFailed = false;
    Serial.println("Trying to write to database to update machine status...");
    while (!Firebase.RTDB.setBool(&fbdo, statusPath.c_str(), newStatus)) {
        if (retryCount > RETRY_COUNT && WiFi.status() != WL_CONNECTED) {
            Serial.println("Max retry attempt reached. Aborting.");
            writeFailed = true;
            break;
        }
        retryCount++;
        digitalWrite(LED_BUILTIN, HIGH);  
        delay(100);
        digitalWrite(LED_BUILTIN, LOW);  
        delay(100);
    }
    if (writeFailed) {
        {
            Serial.println("Failed to reconnect to WiFi. Starting configuration mode...");
            wm->startConfigPortal();
        }
    } else {
        return true;
    }
}

bool FirebaseManager::updateDoorStatus(bool newStatus) {
    int retryCount = 0;
    bool writeFailed = false;    
    Serial.println("Trying to write to database to update door status...");
    while (!Firebase.RTDB.setBool(&fbdo, doorStatusPath.c_str(), newStatus)) {
        if (retryCount > RETRY_COUNT && WiFi.status() != WL_CONNECTED) {
            Serial.println("Max retry attempt reached. Aborting.");
            writeFailed = true;
            break;
        }
        Serial.print("in the loop");
        retryCount++;
        digitalWrite(LED_BUILTIN, HIGH);  
        delay(100);
        digitalWrite(LED_BUILTIN, LOW);  
        delay(100);   
    }
    if (writeFailed) {
        {
            Serial.println("Failed to reconnect to WiFi. Starting configuration mode...");
            wm->startConfigPortal();
        }
    } else {
        return true;
    }
}

bool FirebaseManager::updateThresholdStatus(string threshold, bool newStatus) {
    int retryCount = 0;
    bool writeFailed = false;    
    string thresholdValidityPath = thresholdsPath + threshold;
    Serial.println("Trying to write to database to update threshold validity...");
    while(!Firebase.RTDB.setBool(&fbdo, thresholdValidityPath.c_str(), newStatus)) {
        if (retryCount > RETRY_COUNT && WiFi.status() != WL_CONNECTED) {
            Serial.println("Max retry attempt reached. Aborting.");
            writeFailed = true;
            break;
        }
        retryCount++;
        digitalWrite(LED_BUILTIN, HIGH);  
        delay(100);
        digitalWrite(LED_BUILTIN, LOW);  
        delay(100);       
    }
    if (writeFailed) {
        {
            Serial.println("Failed to reconnect to WiFi. Starting configuration mode...");
            wm->startConfigPortal();
        }
    } else {
        return true;
    }
}

bool FirebaseManager::initDatabase(bool& doorOpen, bool& machineStatus, bool& lowValidityStatus, bool& mediumValidityStatus, bool& highValidityStatus) {    
    if (updateMachineStatus(machineStatus) && 
    updateDoorStatus(doorOpen) && 
    updateThresholdStatus("low", lowValidityStatus) &&
    updateThresholdStatus("medium", mediumValidityStatus) && 
    updateThresholdStatus("high", highValidityStatus) && updateTimeStamp()) {
        return true;
    }
    return false;
}

bool FirebaseManager::updateTimeStamp() {
    int retryCount = 0;
    bool writeFailed = false;    
    unsigned long timestamp = heartbeatManager->getTime();
    if (!timestamp) {
        return false;
    }
    Serial.println("Trying to write to database to update timestamp...");
    while(!Firebase.RTDB.setInt(&fbdo, timestampPath.c_str(), timestamp)) {
        if (retryCount > RETRY_COUNT && WiFi.status() != WL_CONNECTED) {
            Serial.println("Max retry attempt reached. Aborting.");
            writeFailed = true;
            break;
        }
        retryCount++;
        digitalWrite(LED_BUILTIN, HIGH);  
        delay(100);
        digitalWrite(LED_BUILTIN, LOW);  
        delay(100);
    }
    if (writeFailed) {
        {
            Serial.println("Failed to reconnect to WiFi. Starting configuration mode...");
            wm->startConfigPortal();
        }
    } else {
        return true;
    }
}