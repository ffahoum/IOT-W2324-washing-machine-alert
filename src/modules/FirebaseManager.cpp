#include "FirebaseManager.h"

FirebaseManager::FirebaseManager(const char* apiKey, const char* databaseURL) {
  /* Assign the api key (required) */
  config.api_key = apiKey;
  /* Assign the RTDB URL (required) */
  config.database_url = databaseURL;
}


void FirebaseManager::establishConnection() {
    Serial.println("Establishing connection with Firebase Database.");
    while (!Firebase.signUp(&config, &auth, "", "")) {
        Serial.println("trying to connect to firebase");
        Serial.printf("%s\n", config.signer.signupError.message.c_str());
    }
    Firebase.begin(&config, &auth);
    Firebase.reconnectNetwork(true);
    Serial.println("Established connection with Firebase Database.");
}


bool FirebaseManager::updateStatus(bool newStatus) {
    if (Firebase.ready()) {
        while (!Firebase.RTDB.setBool(&fbdo, statusPath.c_str(), newStatus)) {
            Serial.println("Trying to write to database.");
            delay(10);
        }
        return true;
    }
    return false;
}

bool FirebaseManager::readStatus(bool& currentStatus) {
    if (Firebase.ready()) {
        while(!Firebase.RTDB.getBool(&fbdo, statusPath.c_str(), &currentStatus)) {
            Serial.println("Trying to read from database.");
            delay(10);
        }
        return true;
    }
    return false;
}

bool FirebaseManager::updateDoorStatus(bool newStatus) {
    if (Firebase.ready()) {
        while (!Firebase.RTDB.setBool(&fbdo, doorStatusPath.c_str(), newStatus)) {
            Serial.println("Trying to write to database.");
            delay(10);
        }
        return true;
    }
    return false;
}

bool FirebaseManager::readDoorStatus(bool& currentStatus) {
    if (Firebase.ready()) {
        while(!Firebase.RTDB.getBool(&fbdo, doorStatusPath.c_str(), &currentStatus)) {
            Serial.println("Trying to read from database.");
            delay(10);
        }
        return true;
    }
    return false;
}

bool FirebaseManager::initDatabase(bool& doorOpen, bool& machineStatus) {
    if (Firebase.ready()) {
        while(!Firebase.RTDB.setBool(&fbdo, statusPath.c_str(), machineStatus)) {
            Serial.println("Initializing washing machine status...");
            delay(10);
        }
        while(!Firebase.RTDB.setBool(&fbdo, doorStatusPath.c_str(), doorOpen)) {
            Serial.println("Initializing washing machine door status...");
            delay(10);
        }
        return true;
    }
    return false;
}