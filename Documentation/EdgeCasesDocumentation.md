# Edge Cases and Project Robustness

## Edge Case: ESP Failed to Connect to WiFi at Setup

### Explanation:
In the interaction between the ESP and Flutter application, an edge case arises when the ESP device fails to establish a connection with the WiFi network during startup. This issue is mitigated by employing the WiFi Manager library. If the ESP detects the absence of a compatible WiFi network, it autonomously configures itself as an access point. This allows the user to access a dedicated interface through which they can specify the desired WiFi network and its corresponding password.

### Recovery Process:
Upon detecting a failed WiFi connection, the ESP device switches to access point mode, providing the user with a means to input the necessary WiFi network details. Once configured, the ESP attempts to reconnect using the provided credentials. If successful, it establishes a stable connection to the designated WiFi network. If the connection attempt fails again, the ESP device remains in access point mode, allowing the user to review and amend the network settings as needed.

## Edge Case: ESP WiFi Connection Drops After Initial Connection

### Explanation:
Another critical edge case arises when the ESP device loses its WiFi connection subsequent to a successful initial connection. To address this issue, the system incorporates a timeout mechanism set to two minutes. If the ESP fails to reestablish a connection within this timeframe, it automatically transitions into access point mode utilizing the WiFi Manager library. This allows the user to reconfigure the WiFi network settings by providing a new SSID and password.

### Desired Behavior:
This edge case integrates with the system's heartbeat mechanism, designed to inform users of any errors or anomalies encountered by the ESP device. During normal operation, the ESP device regularly updates a timestamp in the database with each loop iteration. However, when the device enters configuration mode, it ceases updating this timestamp. This triggers a scheduled cloud function, prompting it to send a push notification to the user, alerting them to the ESP's configuration status.
When encountering a timeout during the reconnection process in the ESP, we communicate this event to the user by initiating a blinking sequence of the built-in LED on the ESP device.

### Recovery Process:
Upon detecting a dropped WiFi connection, the ESP initiates reconnection attempts for up to two minutes. If reconnection fails within this timeframe, the ESP switches to access point mode. Through the WiFi Manager library, the user gains access to a web portal, allowing them to input new WiFi network credentials. Once configured, the ESP attempts to reconnect to the specified network using the updated credentials.

## Edge Case: ESP Fails to Read or Write to the Firebase Database

### Explanation:
Another crucial edge case occurs when the ESP device encounters difficulties connecting to the Firebase database. This encompasses scenarios such as read/write failures and signup failures. If the issue stems from a connection problem, it overlaps with the "WiFi Dropped After Connection" edge case. However, if the connection issue lies with the Firebase database, the timestamp and heartbeat mechanisms become instrumental in notifying the user of the problem.

### Desired Behavior:
To address this situation, a recovery process is implemented. Upon failure to connect to the Firebase database, the ESP device attempts to write to the database for up to two minutes. If unsuccessful within this timeframe, the heartbeat mechanism is activated. The timestamp mechanism, which normally updates with each loop iteration, fails to update due to the inability to write to the database. As a result, the absence of updates triggers the heartbeat mechanism, alerting the user to the database connection issue.
When encountering a timeout during the database update process in the ESP, we communicate this event to the user by initiating a blinking sequence of the built-in LED on the ESP device.

## Edge Case: User Operates the Application Without WiFi Connection

### Explanation:
A notable edge case arises when the user operates the application without an active WiFi connection. Since the application relies on synchronization with the database for updating machine modes, waiting list counts, and machine statuses, the lack of connectivity poses a significant challenge. Without an internet connection, the application's functionality is compromised, leading to outdated information and potentially disrupting user experience.

### Desired Behavior:
The desired behavior in this scenario involves notifying the user of the connectivity status through a seamless and intuitive mechanism. Utilizing the Connectivity package in Flutter, the application can detect changes in network status. When the connection is lost, a snackbar notification is displayed to the user, indicating the loss of connectivity. Similarly, when the connection is restored, another snackbar notification is presented, alerting the user that connectivity has been regained. This approach mirrors the functionality employed by popular applications such as Instagram and Facebook, enhancing user awareness and experience.

## Edge Case: Application Fails to Read from or Write to the Firebase Database

### Explanation:
An important edge case arises when the application encounters difficulties reading from or writing to the Firebase database. This situation typically occurs when the application needs to perform essential operations such as PIN verification, subscription, or unsubscription. Failure to connect to the Firebase database undermines the functionality and reliability of the application, potentially disrupting user interactions and experiences.

### Desired Behavior:
In response to this edge case, the application implements a proactive approach to handle connection issues with the Firebase database. When the application attempts to connect to Firebase for read/write operations, it does so for a predefined duration of 30 seconds. During this time, if the connection is unsuccessful, the application prompts the user with a dialog indicating the encountered issue. This dialog serves as an immediate notification to the user, informing them of the connectivity problem and encouraging them to take appropriate action.

## Edge Case: Interference from External Magnetic Fields

### Explanation:
An inherent challenge arises when external magnetic fields interfere with the accuracy of magnet sensor measurements. This interference can lead to inaccuracies in detecting the state of the washing machine door, affecting the overall functionality and reliability of the system.

### Handling Mechanism:
To address this issue, the system employs an algorithm specifically designed to mitigate the impact of external magnetic interference. The algorithm utilizes peak-to-peak analysis and applies filtering mechanisms to counteract the effects of external magnetic resources. By implementing these techniques, the system enhances the accuracy of door state detection for washing machines.

## Edge Case: Malicious Vibration Sources

### Explanation:
The system encounters a challenge when malicious vibration sources disrupt the accuracy of acceleration/vibration sensor readings. These disturbances can lead to inaccuracies in detecting the completion of the washing cycle, compromising the reliability of the system.

### Handling Mechanism:
To mitigate the impact of malicious vibration sources, the system employs an algorithm specifically tailored for washing cycle finish identification. This algorithm utilizes a combination of techniques, including peak-to-peak analysis, chunking, and processing a large number of readings. Additionally, the algorithm applies filtering methods to eliminate noise and outliers from the sensor data. By implementing these strategies, the system enhances the accuracy of acceleration/vibration sensor readings, ensuring reliable detection of the washing cycle's completion.
