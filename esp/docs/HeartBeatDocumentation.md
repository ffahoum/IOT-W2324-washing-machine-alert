## Heartbeat Documentation

### Description
The Heartbeat class provides functionality to obtain the current time from an NTP server. It is designed to facilitate time synchronization for various applications requiring accurate timing, such as timestamp updates in data logging systems.

### Properties

#### const char* ntpServer
- **Description:** NTP server used for obtaining time.
- **Type:** Constant Character Pointer
- **Accessibility:** Private

### Methods

#### Heartbeat()
- **Description:** Constructor for the Heartbeat class.
- **Parameters:** None
- **Usage:** Initializes the Heartbeat object and configures the NTP server for time synchronization.

#### unsigned long getTime()
- **Description:** Retrieves the current time from the NTP server.
- **Returns:** The current time in milliseconds since the Unix epoch.
- **Usage:** Call this method to obtain the current time for timestamp updates or other time-sensitive operations.

### Usage
The Heartbeat class is instantiated to manage time synchronization with an NTP server. It provides a simple interface for obtaining the current time, which can be utilized for various timing-related tasks within the application.

### Considerations
- **NTP Server:** The NTP server specified in the `ntpServer` property can be customized based on geographic location and network availability to ensure reliable time synchronization.
- **Error Handling:** The `getTime()` method includes error handling to handle cases where time retrieval from the NTP server fails. Implement additional error handling logic as needed to suit specific application requirements.
