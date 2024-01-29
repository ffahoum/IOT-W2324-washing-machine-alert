// Hall Effect Magnetic Sensor Testing

// Define the pin connected to the Hall Effect sensor
const int sensorPin = 13; // Connect the sensor to pin D13 on the ESP32

void setup() {
  pinMode(sensorPin, INPUT);
  Serial.begin(9600);
}

void loop() {
  int sensorValue = analogRead(sensorPin);
  
  Serial.print("Sensor Value: ");
  Serial.println(sensorValue);
  
  delay(500); // Adjust delay as needed
}