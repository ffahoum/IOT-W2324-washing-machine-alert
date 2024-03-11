#ifndef MagnetSensor_H
#define MagnetSensor_H

class MagnetSensor {
    private:
    int sensorPin;

    public:
    MagnetSensor(int sensorPin);
    bool isOpen();
};

#endif
