#ifndef FirebaseConnection_H
#define FirebaseConnection_H

#include <Firebase_ESP_Client.h>
#include <Arduino.h>

using std::string;

class FirebaseManager {
    private:
    FirebaseAuth auth;
    FirebaseConfig config;
    FirebaseData fbdo;
    string statusPath = "washing_machines/default_id/status/";
    string doorStatusPath = "washing_machines/default_id/door_open/";

    public:
    FirebaseManager(const char* apiKey, const char* databaseURL);
    void establishConnection();
    bool updateStatus(bool newStatus);
    bool readStatus(bool& currentStatus);
    bool updateDoorStatus(bool newStatus);
    bool readDoorStatus(bool& currentStatus);
    bool initDatabase(bool& doorOpen, bool& machineStatus);
};

#endif
