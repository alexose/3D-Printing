#include "LoRaWan_APP.h"
#include "Arduino.h"
#include "softSerial.h"

// Sensor types
#include <I2CSoilMoistureSensor.h>
#include <DHT.h>

#include <Wire.h>


I2CSoilMoistureSensor sensor;

#define timetosleep 1500
#define timetowake 60 * 500 * 5
static TimerEvent_t sleep;
static TimerEvent_t wakeup;
uint8_t lowpower = 1;
bool done = false;

String voltage = "0";

#define RF_FREQUENCY                                868000000
#define TX_OUTPUT_POWER                             10
#define LORA_BANDWIDTH                              0
#define LORA_SPREADING_FACTOR                       11
#define LORA_CODINGRATE                             1
#define LORA_PREAMBLE_LENGTH                        8
#define LORA_SYMBOL_TIMEOUT                         0
#define LORA_FIX_LENGTH_PAYLOAD_ON                  false
#define LORA_IQ_INVERSION_ON                        false
#define RX_TIMEOUT_VALUE                            1000
#define BUFFER_SIZE                                 30

char txPacket[BUFFER_SIZE];

static RadioEvents_t RadioEvents;
void OnTxDone( void );
void OnTxTimeout( void );

softSerial softwareSerial(GPIO1 /*TX pin*/, GPIO2 /*RX pin*/);

typedef enum
{
  LOWPOWER,
  ReadVoltage,
  TX
} States_t;

States_t state;
bool sleepMode = false;
int16_t rssi, rxSize;


void setup() {

  Wire.begin();
  Serial.begin(115200);
  Serial.println( "[stup] INIT");

  sensor.begin(); // reset sensor
  delay(1000);

  rssi = 0;

  RadioEvents.TxDone = OnTxDone;
  RadioEvents.TxTimeout = OnTxTimeout;

  Radio.Init( &RadioEvents );
  Radio.SetChannel( RF_FREQUENCY );
  Radio.SetTxConfig(
    MODEM_LORA,
    TX_OUTPUT_POWER,
    0,
    LORA_BANDWIDTH,
    LORA_SPREADING_FACTOR,
    LORA_CODINGRATE,
    LORA_PREAMBLE_LENGTH,
    LORA_FIX_LENGTH_PAYLOAD_ON,
    true,
    0,
    0,
    LORA_IQ_INVERSION_ON,
    3000
  );

  Radio.SetSyncWord(0x34);

  TimerInit( &sleep, OnSleep );
  TimerInit( &wakeup, OnWakeup );
  OnSleep();
}


uint32_t out_flag_1 = 0;
uint32_t out_flag_2 = 0;
uint32_t t1;
uint32_t t2;

void time1()
{
  out_flag_1 = 1;
  t1 = micros();
}

void time2()
{
  out_flag_2 = 1;
  t2 = micros();
}

void loop()
{
  if (lowpower)
  {
    //note that LowPower_Handler() run six times the mcu into lowpower mode;
    lowPowerHandler();
  } else if (!done) {

    // Turn on device
    pinMode(Vext, OUTPUT);
    digitalWrite(Vext, LOW);
    delay(500);

    // Force I2C reset
    Wire.end();
    Wire.begin();
    Wire.setClock(50000);
    
    // Wire.setClockStretchLimit(2500);  
    
    sensor.begin(); // reset sensor
    delay(1000);
    // while (sensor.isBusy()) delay(50);
    
    // clear buffer with fake reading
    sensor.getCapacitance();
    delay(300);

    // try again?
    int moisture = sensor.getCapacitance();
    delay(300);
    // while (sensor.isBusy()) delay(50); 
    float temperature = sensor.getTemperature()/(float)10;
    delay(300);

    float temperature_f = 1.8 * temperature + 32;
    String temperature_formatted = String(temperature_f, 1);

    Serial.println(moisture);
    Serial.println(temperature);
    Serial.println(temperature_f);

    //sensor.sleep();

     // Read voltage
    pinMode(VBAT_ADC_CTL, OUTPUT);
    digitalWrite(VBAT_ADC_CTL, LOW);
    float c = getBatteryVoltage();
    voltage = String(c / 1000, 4);
    pinMode(VBAT_ADC_CTL, INPUT);
    delay(100);
  
    // Send reading
    Radio.IrqProcess();
    String blah = "17," + temperature_formatted + "," + moisture + "," + voltage;
    Serial.print(blah);
    Radio.Send((uint8_t *)blah.c_str(), blah.length() );
  
    delay(100);
    
    detachInterrupt(GPIO2); // prevents system hang after switching power off
     
    // Turn off device via https://github.com/HelTecAutomation/CubeCell-Arduino/issues/35
    // pinMode(GPIO1, ANALOG);
    // pinMode(GPIO2, ANALOG);
    Wire.end();
    pinMode(Vext, OUTPUT);  
    digitalWrite(Vext, HIGH);
    delay(500);
    Serial.println("---------------------------snoozin----------------------------");

    done = true;
    TimerSetValue( &sleep, timetosleep );
    TimerStart( &sleep );
  }
}

void OnSleep()
{

  
  Serial.printf("[lowp] lowpower mode  %d ms\r\n", timetowake);
  Serial.println("---------------------------zzzzzzzz----------------------------");
  lowpower = 1;
  
  //timetosleep ms later wake up;
  Radio.Sleep();
  TimerSetValue( &wakeup, timetowake );
  TimerStart( &wakeup );
}
void OnWakeup()
{
  Serial.printf("[wkup] wake up, %d ms later into lowpower mode.\r\n", timetosleep);
  uint32_t currentTime = TimerGetCurrentTime() / 1000;
  Serial.printf("[time] upTime: %d sec. \r\n", currentTime);

  done = false;
  lowpower = 0;
}

void OnTxDone( void )
{
  Serial.print("TX done!");
}

void OnTxTimeout( void )
{
  Serial.print("TX Timeout......");
}
