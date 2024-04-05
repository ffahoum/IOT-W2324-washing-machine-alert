## FirebaseManager Documentation

### Description
The `FirebaseManager` class facilitates the connection with the Firebase database and handles data updates related to washing machine status, door status, threshold validity, and timestamp.

### Properties

#### FirebaseAuth auth
- **Description:** Firebase authentication object.
- **Type:** FirebaseAuth
- **Accessibility:** Private
- **Usage:** Used for authenticating the Firebase connection.

#### FirebaseConfig config
- **Description:** Firebase configuration object.
- **Type:** FirebaseConfig
- **Accessibility:** Private
- **Usage:** Stores the Firebase configuration parameters.

#### FirebaseData fbdo
- **Description:** Firebase data object.
- **Type:** FirebaseData
- **Accessibility:** Private
- **Usage:** Used for handling data operations with Firebase.

#### Heartbeat* heartbeatManager
- **Description:** Pointer to the Heartbeat and timestamp manager.
- **Type:** Heartbeat*
- **Accessibility:** Private
- **Usage:** Used to retrieve the current timestamp for updating in Firebase.

#### WiFiController* wm
- **Description:** Pointer to the WiFi manager.
- **Type:** WiFiController*
- **Accessibility:** Private
- **Usage:** Used for handling WiFi connectivity, particularly during connection failures.

#### std::string statusPath, doorStatusPath, thresholdsPath, timestampPath
- **Description:** Paths for updating different data points in Firebase.
- **Type:** std::string
- **Accessibility:** Private
- **Usage:** Specifies the paths for updating machine status, door status, thresholds, and timestamp in the Firebase database.

### Methods

#### FirebaseManager(Heartbeat* heartbeatManager)
- **Description:** Constructor to initialize the FirebaseManager object.
- **Parameters:** 
  - `heartbeatManager`: Pointer to the Heartbeat and timestamp manager.
- **Usage:** Initializes a new instance of the FirebaseManager class with the specified heartbeat manager.

#### void establishConnection()
- **Description:** Establishes connection with the Firebase database.
- **Usage:** Call this method to connect with the Firebase database. It handles connection retries and reconnection in case of failures.

#### bool updateMachineStatus(bool newStatus)
- **Description:** Updates the machine status in Firebase.
- **Parameters:** 
  - `newStatus`: The new status to be updated.
- **Returns:** 
  - `true`: If the update is successful.
  - `false`: If the update fails.
- **Usage:** Call this method to update the machine status in the Firebase database with the provided new status.

#### bool updateDoorStatus(bool newStatus)
- **Description:** Updates the door status in Firebase.
- **Parameters:** 
  - `newStatus`: The new door status to be updated.
- **Returns:** 
  - `true`: If the update is successful.
  - `false`: If the update fails.
- **Usage:** Call this method to update the door status in the Firebase database with the provided new status.

#### bool updateThresholdStatus(string threshold, bool newStatus)
- **Description:** Updates the threshold status in Firebase.
- **Parameters:** 
  - `threshold`: The threshold to update (e.g., "low", "medium", "high").
  - `newStatus`: The new threshold status to be updated.
- **Returns:** 
  - `true`: If the update is successful.
  - `false`: If the update fails.
- **Usage:** Call this method to update the threshold status in the Firebase database with the provided new status.

#### bool updateTimeStamp()
- **Description:** Updates the timestamp in Firebase.
- **Returns:** 
  - `true`: If the update is successful.
  - `false`: If the update fails.
- **Usage:** Call this method to update the timestamp in the Firebase database with the current timestamp.

#### bool initDatabase(bool& doorOpen, bool& machineStatus, bool& lowValidityStatus, bool& mediumValidityStatus, bool& highValidityStatus)
- **Description:** Initializes the database with initial status values.
- **Parameters:** 
  - `doorOpen`: The initial door status.
  - `machineStatus`: The initial machine status.
  - `lowValidityStatus`: The initial low threshold validity status.
  - `mediumValidityStatus`: The initial medium threshold validity status.
  - `highValidityStatus`: The initial high threshold validity status.
- **Returns:** 
  - `true`: If initialization is successful.
  - `false`: If initialization fails.
- **Usage:** Call this method to initialize the Firebase database with the provided initial status values.

### Define Definitions

#### DATABASE_URL
- **Description:** URL of the Firebase database.
- **Type:** String
- **Value:** "https://wash-watch-default-rtdb.firebaseio.com/"
- **Usage:** Specifies the URL of the Firebase database to establish connection.

#### API_KEY
- **Description:** API key for Firebase authentication.
- **Type:** String
- **Value:** "AIzaSyDBaDc85VryAXFR574PeZaoPaQe-OAUnMQ"
- **Usage:** Provides the API key required for authenticating the Firebase connection.

#### WASHING_MACHINE_ID
- **Description:** Identifier for the washing machine.
- **Type:** String
- **Value:** "eco_clean_pro"
- **Usage:** Specifies the identifier for the washing machine in the Firebase database.

#### RETRY_COUNT
- **Description:** Maximum retry count for connection and update attempts.
- **Type:** Integer
- **Value:** 600
- **Usage:** Defines the maximum number of retry attempts for connection and update operations before aborting.

### Insights on Define Definitions
- **DATABASE_URL:** The URL of the Firebase database was obtained from the Firebase console and used to establish a connection with the correct database.
- **API_KEY:** The API key was generated from the Firebase console and used for authentication to access the Firebase services securely.
- **WASHING_MACHINE_ID:** The washing machine identifier is a unique identifier used to specify the location of data updates in the Firebase database.
- **RETRY_COUNT:** The maximum retry count ensures robustness against intermittent connection failures by allowing multiple retry attempts before aborting the operation.

## Firebase Manager Connection Retry Mechanism

### Description
The Firebase Manager class implements a robust connection retry mechanism to handle intermittent connection failures with the Firebase database. This mechanism includes waiting for a certain duration before attempting reconnection and switching the ESP device to access point mode for manual Wi-Fi configuration if connection attempts fail repeatedly.

### Connection Retry Mechanism
When attempting to update data in the Firebase database, the Firebase Manager class implements the following connection retry mechanism:

1. **Retry Attempts:** If the initial connection or data update attempt fails, the system retries the operation a predefined number of times (`RETRY_COUNT`). During each retry attempt, the LED built into the ESP device blinks to indicate the retry process.

2. **Timeout:** If the maximum retry count is reached without establishing a successful connection or data update, the system checks the Wi-Fi connection status. If the Wi-Fi connection is not available (`WiFi.status() != WL_CONNECTED`), it proceeds to the next step.

3. **Configuration Mode:** The system enters configuration mode by starting the auto-connect Wi-Fi manager (`wm->startConfigPortal()`). In this mode, the ESP device acts as an access point, allowing users to connect to it using a Wi-Fi-enabled device (e.g., smartphone, laptop) and configure the Wi-Fi network and password manually.

4. **Blinking LED:** Throughout the connection retry mechanism, the LED built into the ESP device blinks periodically to provide visual feedback to the user, indicating that the device is attempting to establish a connection or update data in the Firebase database.

### Usage
The connection retry mechanism is automatically invoked whenever a connection attempt or data update operation fails due to network issues or other connectivity issues. Users do not need to manually trigger this mechanism; it is integrated into the Firebase Manager class for seamless operation.

### Considerations
- **Timeout Duration:** The timeout duration for waiting before entering configuration mode (`MAX_RETRY_DURATION`) can be adjusted based on specific use cases and network conditions to optimize performance and user experience.

- **LED Blinking Interval:** The interval at which the LED blinks during the retry mechanism (`LED_BLINK_INTERVAL`) can be customized to suit user preferences and visibility requirements.

- **Feedback to Users:** The LED blinking serves as visual feedback to users, indicating the status of the connection retry process. It enhances user experience by providing clear indications of ongoing connection attempts or configuration mode activation.
