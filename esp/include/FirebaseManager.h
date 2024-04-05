#ifndef FirebaseConnection_H
#define FirebaseConnection_H

#include <Firebase_ESP_Client.h>
#include "Heartbeat.h"
#include <Arduino.h>
#include "WiFiController.h"

using std::string;

// Define the class for managing Firebase connection and data updates
class FirebaseManager {
    private:
    FirebaseAuth auth; // Firebase authentication object
    FirebaseConfig config; // Firebase configuration object
    FirebaseData fbdo; // Firebase data object
    Heartbeat* heartbeatManager; // Heartbeat and timestamp manager
    WiFiController* wm; // WiFi manager 
    std::string statusPath; // Path for updating machine status in Firebase
    std::string doorStatusPath; // Path for updating door status in Firebase
    std::string thresholdsPath; // Path for updating threshold status in Firebase
    std::string timestampPath; // Path for updating timestamp in Firebase

    public:

    /**
     * @brief Constructor to initialize FirebaseManager object.
    */    
    FirebaseManager(Heartbeat* heartbeatManager);

    /**
     * @brief Function to establish connection with Firebase database.
     */
    void establishConnection();

    /**
     * @brief Updates the machine status in Firebase.
     * 
     * @param newStatus The new status to be updated.
     * @return true if the update is successful, false otherwise.
     */    
    bool updateMachineStatus(bool newStatus);

    /**
     * @brief Updates the door status in Firebase.
     * 
     * @param newStatus The new door status to be updated.
     * @return true if the update is successful, false otherwise.
     */    
    bool updateDoorStatus(bool newStatus);

    /**
     * @brief Updates the threshold status in Firebase.
     * 
     * @param threshold The threshold to update (e.g., "low", "medium", "high").
     * @param newStatus The new threshold status to be updated.
     * @return true if the update is successful, false otherwise.
     */    
    bool updateThresholdStatus(string threshold, bool newStatus);

    /**
     * @brief Updates the timestamp in Firebase.
     * 
     * @return true if the update is successful, false otherwise.
     */    
    bool updateTimeStamp();    

    /**
     * @brief Initializes the database with initial status values.
     * 
     * @param doorOpen The initial door status.
     * @param machineStatus The initial machine status.
     * @param lowValidityStatus The initial low threshold validity status.
     * @param mediumValidityStatus The initial medium threshold validity status.
     * @param highValidityStatus The initial high threshold validity status.
     * @return true if initialization is successful, false otherwise.
     */    
    bool initDatabase(bool& doorOpen, bool& machineStatus, bool& lowValidityStatus, bool& mediumValidityStatus, bool& highValidityStatus);

};

#endif
