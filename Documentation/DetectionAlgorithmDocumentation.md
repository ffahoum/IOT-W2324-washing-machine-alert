# Vibration Detection Algorithm

## Overview
The vibration detection algorithm is designed to determine the presence of significant vibrations using an acceleration sensor. By analyzing sensor readings, it evaluates whether vibration activity surpasses a predefined threshold, indicating potential movement or disturbance.

## Steps:

### Initialization:
The algorithm initializes the sensor by configuring its parameters such as accelerometer and gyro ranges, and filter bandwidth. If initialization is successful, a flag initialized is set to true; otherwise, it's set to false.

### Update Sensor Data:
The `update()` function retrieves accelerometer data (specifically x, y, and z-axis acceleration values) from the sensor and stores them internally.

### Vibration Detection:
The `isVibrating()` function determines if vibration is detected by taking multiple readings over a period.
- It iterates through a loop `READINGS_NUM` times, each time retrieving accelerometer data and storing it in a matrix of readings along with calculating the vibration intensity for each reading.
- Vibration intensity is calculated by summing the absolute values of x, y, and z-axis accelerations.
- To simplify analysis, readings are grouped into chunks of size `CHUNK_SIZE`.
- For each chunk, the maximum vibration intensity is calculated and stored in an array `maxPerChunk`.
- The algorithm then checks how many of these maximum values fall below a predefined threshold `ZERO_VIBRATIONS_PEAK`.
  - If more than 75% of the chunks have maximum values below the threshold, the function returns false, indicating no vibration. Otherwise, it returns true, indicating vibration detection.

### Exception Handling:
Both the `update()` and `isVibrating()` functions include exception handling to ensure the sensor is properly initialized before attempting to read or analyze data. If the sensor is not initialized, it throws a `SensorNotInitializedException`.

## Insight:

### Handling Deviation and Noise:
The algorithm employs a chunking mechanism to handle deviation and noise in readings. By grouping readings into chunks and calculating the maximum vibration intensity per chunk, it reduces the impact of individual outliers on the overall result. Additionally, the algorithm utilizes a predefined threshold to distinguish significant vibrations from background noise.

## Formula for Vibration Intensity Calculation:
In our project, when selecting a formula to calculate total vibrations from an acceleration sensor, we deliberated between two options: |X|+|Y|+|Z| and sqrt(X^2+Y^2+Z^2) where X, Y, Z stand for the acceleration in each axis accordingly. After numerous iterations of readings and considering the influence of gravity acceleration within the vibrations, we opted for the former formula. This decision was made to ensure the accuracy of the total result, mitigating any distortion caused by the dominant gravitational element. This rationale has been documented in our project files to provide clarity and transparency regarding our methodology.

## Balancing Act: The Tradeoffs Between Readings Quantity and System Responsiveness

When considering the tradeoffs between a large number of readings and responsiveness in a system, a balance must be struck to ensure optimal performance. A large number of readings offers the advantage of robustness against outliers and fluctuations in data. By accumulating a significant volume of readings, the system can effectively filter out noise and identify patterns with higher accuracy. However, this comes at the expense of responsiveness, as processing a large dataset introduces latency and may result in slower system response times.

On the other hand, prioritizing interactivity and swift response necessitates a smaller number of readings. A streamlined approach reduces processing overhead and enables quicker decision-making, enhancing user experience and system agility. Nonetheless, this approach may be more susceptible to outliers and variability in data, potentially compromising the reliability and accuracy of results.

After thorough fine-tuning and consideration of these tradeoffs, a balance was struck, and a compromise of 1000 readings was chosen. This number strikes a balance between robustness against outliers afforded by a larger dataset and the responsiveness required for timely system interaction. It provides a sufficient volume of data to mitigate the impact of outliers while maintaining an acceptable level of responsiveness, ensuring an optimal balance between accuracy and efficiency in system operation.
