# Parameters

## Firebase Manager Module Parameters

### DATABASE_URL
- **Description:** URL of the Firebase database.
- **Type:** String
- **Value:** "https://wash-watch-default-rtdb.firebaseio.com/"
- **Usage:** Specifies the URL of the Firebase database to establish connection.

### API_KEY
- **Description:** API key for Firebase authentication.
- **Type:** String
- **Value:** "AIzaSyDBaDc85VryAXFR574PeZaoPaQe-OAUnMQ"
- **Usage:** Provides the API key required for authenticating the Firebase connection.

### WASHING_MACHINE_ID
- **Description:** Identifier for the washing machine.
- **Type:** String
- **Value:** "eco_clean_pro"
- **Usage:** Specifies the identifier for the washing machine in the Firebase database.

### RETRY_COUNT
- **Description:** Maximum retry count for connection and update attempts.
- **Type:** Integer
- **Value:** 600
- **Usage:** Defines the maximum number of retry attempts for connection and update operations before aborting.

## Magnet Sensor Module Parameters

### READINGS_NUM
- **Description:** Number of readings for magnet field detection.
- **Type:** Integer
- **Value:** 100
- **Usage:** Specifies the number of readings to be taken for magnet field detection.

### DOOR_CLOSED_THRESHOLD
- **Description:** Threshold value for determining if the door is closed.
- **Type:** Integer
- **Value:** 4095
- **Usage:** Defines the threshold value above which the sensor indicates a closed state. Readings below this threshold are considered to indicate an open state.


## Vibration Sensor Module Parameters

### READINGS_NUM
- **Description:** Defines the total number of readings to be stored.
- **Type:** Integer
- **Value:** 1000
- **Usage:** Used to specify the size of arrays or buffers for storing sensor readings. 

### CHUNK_SIZE
- **Description:** Defines the size of each chunk for processing sensor readings.
- **Type:** Integer
- **Value:** 30
- **Usage:** Used to determine the number of readings processed together as a chunk for peak detection and analysis.

### ZERO_VIBRATIONS_PEAK
- **Description:** Defines the peak value indicating zero vibrations.
- **Type:** Integer
- **Value:** 12
- **Usage:** Used as a threshold to determine zero vibrations based on the maximum vibration peak per chunk.
- **Insight:** This constant was determined through testing and fine-tuning the algorithm on various scenarios. It represents the baseline level of vibration intensity that can be considered as negligible. By setting this threshold appropriately, the algorithm can effectively differentiate between vibrations and background noise.

### LOW_VIBRATION_THRESHOLD
- **Description:** Defines the low threshold for vibration intensity.
- **Type:** Integer
- **Value:** 17
- **Usage:** Represents the threshold below which vibration intensity is considered low.
- **Insight:** This threshold were established through iterative testing and adjustment of the algorithm to ensure that valid vibration intensities are accurately categorized within each intensity level. By analyzing sensor data and observing the distribution of vibration intensities, appropriate threshold values were chosen to validate the accuracy of vibration detection.

### MEDIUM_VIBRATION_THRESHOLD
- **Description:** Defines the medium threshold for vibration intensity.
- **Type:** Integer
- **Value:** 26
- **Usage:** Represents the threshold for moderate vibration intensity.
- **Insight:** This threshold were established through iterative testing and adjustment of the algorithm to ensure that valid vibration intensities are accurately categorized within each intensity level. By analyzing sensor data and observing the distribution of vibration intensities, appropriate threshold values were chosen to validate the accuracy of vibration detection.

### HIGH_VIBRATION_THRESHOLD
- **Description:** Defines the high threshold for vibration intensity.
- **Type:** Integer
- **Value:** 40
- **Usage:** Represents the threshold for high vibration intensity.
- **Insight:** This threshold were established through iterative testing and adjustment of the algorithm to ensure that valid vibration intensities are accurately categorized within each intensity level. By analyzing sensor data and observing the distribution of vibration intensities, appropriate threshold values were chosen to validate the accuracy of vibration detection.

### VALID_THRESHOLD_RANGE
- **Description:** Defines the valid threshold range.
- **Type:** Integer
- **Value:** 3
- **Usage:** Represents the range within which vibration intensity is considered valid.
- **Insight:** The determination of the valid threshold range was driven by the need to account for variations in vibration intensity measurements and sensor noise. By analyzing sensor data and observing the range of values recorded during different vibration events, a suitable range was defined to ensure the algorithm's robustness against noise and fluctuations.



## WiFi Controller Module Parameters

### `AP_SSID`

- **Usage**: This constant defines the SSID (Service Set Identifier) for the WiFi access point.
- **Value Type**: String
- **Description**: The SSID represents the name of the WiFi network that the ESP device will broadcast when operating in access point mode.
- **Usage Insight**: It is essential to set a unique and recognizable SSID for the access point to facilitate easy identification by users when connecting their devices. Choosing a descriptive SSID like "EcoClean Pro" helps users quickly identify and select the correct network from available options.

### `AP_PASSWORD`

- **Usage**: This constant defines the password required to connect to the WiFi access point.
- **Value Type**: String
