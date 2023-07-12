#include <SPI.h>
#include <WiFi.h>
#include <WiFiUDP.h>
#include "DHTesp.h"
#include "heltec.h"
#include <Wire.h>

#define BAND    868E6  //you can set band here directly,e.g. 868E6,915E6

String rssi = "RSSI --";
String packSize = "--";
String packet ;

char ssid[] = "";     //  your network SSID (name) 
char pass[] = "";    // your network password
int status = WL_IDLE_STATUS;     // the Wifi radio's status

// the IP address of your InfluxDB host
byte host[] = {192, 168, 1, 46};

// the port that the InfluxDB UDP plugin is listening on
int port = 8089;

WiFiUDP udp;

void setup() {

  Heltec.begin(true /*DisplayEnable Enable*/, true /*Heltec.Heltec.Heltec.LoRa Disable*/, true /*Serial Enable*/, true /*PABOOST Enable*/, BAND /*long BAND*/);
  Heltec.display->init();
  Heltec.display->flipScreenVertically();  
  Heltec.display->setFont(ArialMT_Plain_10);

  LoRa.setSpreadingFactor(11);
  // put in standby mode
  // LoRa.setSignalBandwidth(125E3);

  delay(2000);

  adcAttachPin(37);
  analogSetClockDiv(255); // 1338mS

  Heltec.display->drawString(0, 0, "Connecting to ");
  Heltec.display->drawString(0, 10, ssid);
  Heltec.display->display();

  LoRa.dumpRegisters(Serial);
  
  // initialize serial port
  Serial.begin(9600);

  // attempt to connect using WPA2 encryption
  Serial.println("Attempting to connect to WPA network...");
  WiFi.disconnect();
  delay(10);
  status = WiFi.begin(ssid, pass);
  
  while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Heltec.display->drawString(0, 20, ".");
      Heltec.display->display();
      Serial.println(WiFi.status());

  }
  
  // if the connection succeeded, print network info
  Serial.println("Connected to network");
  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  
  Serial.print("IP Address: ");
  Serial.println(ip);

  Heltec.display->drawString(0, 30, "Connected! IP: ");
  Heltec.display->drawString(0, 40, ip.toString().c_str());
  Heltec.display->display();
  
  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
  digitalWrite(21,LOW);

  LoRa.receive();
}

void LoRaData(){
  String line;
  
  char str_array[packet.length() + 1];
  packet.toCharArray(str_array, packet.length());
  
  Heltec.display->clear();
  Heltec.display->setTextAlignment(TEXT_ALIGN_LEFT);
  Heltec.display->setFont(ArialMT_Plain_10);
  Heltec.display->drawStringMaxWidth(0 , 26 , 128, packet);
  Heltec.display->drawString(0, 0, rssi);  
  Heltec.display->display();

  // send the packet
  Serial.println("Sending UDP packet...");
  Serial.println(packet);

  udp.beginPacket(host, port);
  udp.print(packet);
  udp.endPacket();

  digitalWrite(25,LOW);
  Serial.println("Done!");
}

void cbk(int packetSize) {
  packet ="";
  packSize = String(packetSize,DEC);
  for (int i = 0; i < packetSize; i++) { packet += (char) LoRa.read(); }
  rssi = "RSSI " + String(LoRa.packetRssi(), DEC) ;
  LoRaData();
}

void loop() {
  int packetSize = LoRa.parsePacket();
  if (packetSize) { cbk(packetSize);  }
  delay(50);

  if (WiFi.status() != WL_CONNECTED){
    Heltec.display->drawString(0, 0, "Wifi disconnected...");
    Heltec.display->display();
    delay(2000);
    setup();
    return;
  }
}
