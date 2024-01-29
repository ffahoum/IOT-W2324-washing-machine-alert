// Vibration Motor Module Testing for ESP32

// Define the pin connected to the vibration motor
const int motorPin = 23; // Connect the motor to pin D23 on the ESP32

const int interval = 1000; 

void setup() {
  pinMode(motorPin, OUTPUT);
}

void loop() {

  for (int intensity = 0; intensity <= 255; intensity++) {
    analogWrite(motorPin, intensity);
    delay(interval);
  }
  delay(interval);

  for (int intensity = 255; intensity >= 0; intensity--) {
    analogWrite(motorPin, intensity);
    delay(interval);
  }
  delay(interval);
}