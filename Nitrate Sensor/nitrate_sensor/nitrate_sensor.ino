/*
  Using the AMS AS7331 Spectral UV Sensor in Command/One Shot (CMD) Mode.

  This example shows how operate the AS7331 in the default CMD mode. The start 
  command is sent, then delays until the conversion time has passed before
  reading out the UV values.

  By: Alex Brudner
  SparkFun Electronics
  Date: 2023/11/17
  SparkFun code, firmware, and software is released under the MIT License.
	Please see LICENSE.md for further details.

  Hardware Connections:
  IoT RedBoard --> AS7331
  QWIIC --> QWIIC

  Serial.print it out at 115200 baud to serial monitor.

  Feel like supporting our work? Buy a board from SparkFun!
  https://www.sparkfun.com/products/23517 - Qwiic 1x1
  https://www.sparkfun.com/products/23518 - Qwiic Mini
*/

#include <Arduino.h>
#include <Wire.h>
#include <SparkFun_AS7331.h>
#include "heltec.h"

SfeAS7331ArdI2C myUVSensor;

void setup() {
  Heltec.begin(true /*DisplayEnable Enable*/, false /*LoRa Disable*/, true /*Serial Enable*/);
  Serial.begin(115200);
  delay(2000);
  while (!Serial) { delay(100); };
  
  Serial.println("AS7331 UV A/B/C Command (One-shot) mode Example.");
  Heltec.display->init();
  Heltec.display->setFont(ArialMT_Plain_16);
  Heltec.display->flipScreenVertically();
  Heltec.display->clear();

  Wire1.begin(3, 4);  // SDA on GPIO3, SCL on GPIO4

  // Initialize sensor and run default setup.
  if (myUVSensor.begin(kDefaultAS7331Addr, Wire1) == false) {
    Serial.println("Sensor failed to begin. Please check your wiring!");
    Serial.println("Halting...");
    while (1);
  }

  setupGain();
  Serial.println("Sensor began.");

  // Set measurement mode and change device operating mode to measure.
  if (myUVSensor.prepareMeasurement(MEAS_MODE_CMD) == false) {
    Serial.println("Sensor did not get set properly.");
    Serial.println("Halting...");
    while (1)
      ;
  }

  Serial.println("Set mode to command.");
}

void setupGain() {
  as7331_gain_t desiredGain = GAIN_16;
  sfeTkError_t result = myUVSensor.setGain(desiredGain);
  if (result != kSTkErrOk) {
    Serial.println("Failed to set gain!");
    // Handle the error, e.g., retry or use a default gain setting
  } else {
    Serial.println("Gain set successfully.");
  }
}

void loop() {

  // Send a start measurement command.


  if (kSTkErrOk != myUVSensor.setStartState(true))
    Serial.println("Error starting reading!");

  // Wait for a bit longer than the conversion time.
  delay(2 + myUVSensor.getConversionTimeMillis());

  // Read UV values.
  if (kSTkErrOk != myUVSensor.readAllUV())
    Serial.println("Error reading UV.");

  // Serial.print("UVA:");
  // Serial.print(myUVSensor.getUVA());
  // Serial.print(" UVB:");
  // Serial.print(myUVSensor.getUVB());
  // Serial.print(" UVC:");
  // Serial.println(myUVSensor.getUVC());
  String output = String(myUVSensor.getUVA()) + ", " + String(myUVSensor.getUVB()) + ", " + String(myUVSensor.getUVC());
  Serial.println(output);
  display(output);
  delay(200);
}

void display(String message) {
  Heltec.display->clear();
  Heltec.display->drawString(3, 15, message);
  Heltec.display->display();
}
