#include <Arduino.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

const int VibrationPin = 23;
Adafruit_MPU6050 mpu;

float vibrationThreshold = 1.0; // Adjust the threshold as needed

void initializeMPU6050() {
  Serial.println("Adafruit MPU6050 test!");

  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }

  Serial.println("MPU6050 Found!");

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  Serial.println("");
  delay(100);
}

bool isVibrationOn(sensors_event_t &a) {
  // Check if any acceleration component exceeds the threshold
  return (abs(a.acceleration.x) > vibrationThreshold);
}

void controlVibration(bool state, int duration) {
  analogWrite(VibrationPin, state ? 255 : 0);
  Serial.println(state ? "Vibration On" : "Vibration Off");
  delay(duration);
}

void readMpuValue() {
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  Serial.print("Acceleration X: ");
  Serial.print(a.acceleration.x);
  Serial.print(", Y: ");
  Serial.print(a.acceleration.y);
  Serial.print(", Z: ");
  Serial.print(a.acceleration.z);
  Serial.println(" m/s^2");

  Serial.print("Rotation X: ");
  Serial.print(g.gyro.x);
  Serial.print(", Y: ");
  Serial.print(g.gyro.y);
  Serial.print(", Z: ");
  Serial.print(g.gyro.z);
  Serial.println(" rad/s");

  Serial.print("Temperature: ");
  Serial.print(temp.temperature);
  Serial.println(" degC");

  // Check if vibration module should be on or off
  bool vibrationState = isVibrationOn(a);
  Serial.println(vibrationState ? "Detected Vibration On" : "Detected Vibration Off");

  Serial.println("");
  delay(500);

}

void setup(void) {
  Serial.begin(9600);
  while (!Serial) {
    Serial.println("Failed to find MPU6050 chip");
    delay(10);
  }
  Serial.println("MPU6050 Found!");
  pinMode(VibrationPin, OUTPUT);
  initializeMPU6050();
}

void loop() {
  controlVibration(true, 1000);
  readMpuValue();
  controlVibration(false, 1000);
  readMpuValue();
}
