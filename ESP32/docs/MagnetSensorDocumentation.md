## MagnetSensor Documentation

### Description
The `MagnetSensor` class provides functionality to read the state of a magnetic sensor connected to an analog pin of the microcontroller. It determines whether the magnetic sensor indicates an open or closed state.

### Properties

#### int sensorPin
- **Description:** The analog pin connected to the magnetic sensor.
- **Type:** Integer
- **Accessibility:** Private
- **Usage:** Specifies the pin through which the microcontroller reads the magnetic sensor's analog output.

### Methods

#### MagnetSensor(int sensorPin)
- **Description:** Constructs a new MagnetSensor object.
- **Parameters:** 
  - `sensorPin`: The analog pin connected to the magnetic sensor.
- **Usage:** Initializes a new instance of the MagnetSensor class with the specified sensor pin.

#### bool isOpen()
- **Description:** Checks if the magnetic sensor indicates an open state.
- **Returns:** 
  - `true`: If the sensor indicates an open state.
  - `false`: If the sensor indicates a closed state.
- **Usage:** Reads the analog value from the sensor pin multiple times, and if the majority of readings are below a certain threshold, it is considered that the sensor indicates an open state.

### Define Definitions

### READINGS_NUM
- **Description:** Number of readings for magnet field detection.
- **Type:** Integer
- **Value:** 100
- **Usage:** Specifies the number of readings to be taken for magnet field detection.

#### DOOR_CLOSED_THRESHOLD
- **Description:** Threshold value for determining if the door is closed.
- **Type:** Integer
- **Value:** 4095
- **Usage:** Defines the threshold value above which the sensor indicates a closed state. Readings below this threshold are considered to indicate an open state.

### Insights on Define Definitions
- **READINGS_NUM:** The value of 100 was chosen through experimentation and testing to ensure an adequate number of readings for sensor calibration, balancing accuracy with efficiency.
- **DOOR_CLOSED_THRESHOLD:** The threshold value of 4095 was determined based on the range of analog readings obtained from the magnetic sensor when the door is closed. It was fine-tuned to accurately detect the closed state while minimizing false positives.
