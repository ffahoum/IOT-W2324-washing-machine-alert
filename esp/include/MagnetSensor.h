#ifndef MagnetSensor_H
#define MagnetSensor_H

/**
 * @brief A class for reading the state of a magnetic sensor.
 * 
 * This class provides functionality to read the state of a magnetic sensor
 * connected to an analog pin of the microcontroller. It determines if the 
 * magnetic sensor indicates an open or closed state.
 */
class MagnetSensor {
private:
    int sensorPin; /**< The analog pin connected to the magnetic sensor. */

public:
    /**
     * @brief Constructs a new MagnetSensor object.
     * 
     * @param sensorPin The analog pin connected to the magnetic sensor.
     */
    MagnetSensor(int sensorPin);

    /**
     * @brief Check if the magnetic sensor indicates an open state.
     * 
     * This function reads the analog value from the sensor pin multiple times,
     * and if the majority of readings are below a certain threshold, it is
     * considered that the sensor indicates an open state.
     * 
     * @return true if the sensor indicates an open state, false otherwise.
     */
    bool isOpen();
};

#endif
