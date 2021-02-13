#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_ADXL345_U.h>

#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
RF24 radio(2, 15);

#include "FirebaseESP8266.h"
#include <ESP8266WiFi.h>

#define FIREBASE_HOST "mqtt-846f8.firebaseio.com"
#define FIREBASE_AUTH "25VrMhC1XbQKyGheKHQOdBAiFvXL0RZJL2ZLua9I"
#define WIFI_SSID "NEW_WORLD"
#define WIFI_PASSWORD "Baba8899"

const byte address[6] = "00001";
 
/* Assign a unique ID to this sensor at the same time */
Adafruit_ADXL345_Unified accel = Adafruit_ADXL345_Unified(12345);
 
void displaySensorDetails(void)
{
 sensor_t sensor;
 accel.getSensor(&sensor);
 Serial.println("------------------------------------");
 Serial.print ("Sensor: "); Serial.println(sensor.name);
 Serial.print ("Driver Ver: "); Serial.println(sensor.version);
 Serial.print ("Unique ID: "); Serial.println(sensor.sensor_id);
 Serial.print ("Max Value: "); Serial.print(sensor.max_value); Serial.println(" m/s^2");
 Serial.print ("Min Value: "); Serial.print(sensor.min_value); Serial.println(" m/s^2");
 Serial.print ("Resolution: "); Serial.print(sensor.resolution); Serial.println(" m/s^2"); 
 Serial.println("------------------------------------");
 Serial.println("");
 delay(500);
}
 
void displayDataRate(void)
{
 Serial.print ("Data Rate: "); 
 
 switch(accel.getDataRate())
 {
 case ADXL345_DATARATE_3200_HZ:
 Serial.print ("3200 "); 
 break;
 case ADXL345_DATARATE_1600_HZ:
 Serial.print ("1600 "); 
 break;
 case ADXL345_DATARATE_800_HZ:
 Serial.print ("800 "); 
 break;
 case ADXL345_DATARATE_400_HZ:
 Serial.print ("400 "); 
 break;
 case ADXL345_DATARATE_200_HZ:
 Serial.print ("200 "); 
 break;
 case ADXL345_DATARATE_100_HZ:
 Serial.print ("100 "); 
 break;
 case ADXL345_DATARATE_50_HZ:
 Serial.print ("50 "); 
 break;
 case ADXL345_DATARATE_25_HZ:
 Serial.print ("25 "); 
 break;
 case ADXL345_DATARATE_12_5_HZ:
 Serial.print ("12.5 "); 
 break;
 case ADXL345_DATARATE_6_25HZ:
 Serial.print ("6.25 "); 
 break;
 case ADXL345_DATARATE_3_13_HZ:
 Serial.print ("3.13 "); 
 break;
 case ADXL345_DATARATE_1_56_HZ:
 Serial.print ("1.56 "); 
 break;
 case ADXL345_DATARATE_0_78_HZ:
 Serial.print ("0.78 "); 
 break;
 case ADXL345_DATARATE_0_39_HZ:
 Serial.print ("0.39 "); 
 break;
 case ADXL345_DATARATE_0_20_HZ:
 Serial.print ("0.20 "); 
 break;
 case ADXL345_DATARATE_0_10_HZ:
 Serial.print ("0.10 "); 
 break;
 default:
 Serial.print ("???? "); 
 break;
 } 
 Serial.println(" Hz"); 
}
 
void displayRange(void)
{
 Serial.print ("Range: +/- "); 
 
 switch(accel.getRange())
 {
 case ADXL345_RANGE_16_G:
 Serial.print ("16 "); 
 break;
 case ADXL345_RANGE_8_G:
 Serial.print ("8 "); 
 break;
 case ADXL345_RANGE_4_G:
 Serial.print ("4 "); 
 break;
 case ADXL345_RANGE_2_G:
 Serial.print ("2 "); 
 break;
 default:
 Serial.print ("?? "); 
 break;
 } 
 Serial.println(" g"); 
}

FirebaseData firebaseData;
 
void setup(void) 
{
 Serial.begin(9600);
 
 radio.begin();
 radio.openWritingPipe(address);
 radio.setPALevel(RF24_PA_MIN);
 radio.stopListening();

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
 
 /* Initialise the sensor */
 if(!accel.begin())
 {
 /* There was a problem detecting the ADXL345 ... check your connections */
 Serial.println("Ooops, no ADXL345 detected ... Check your wiring!");
 while(1);
 }
 
 /* Set the range to whatever is appropriate for your project */
 accel.setRange(ADXL345_RANGE_16_G);
 // displaySetRange(ADXL345_RANGE_8_G);
 // displaySetRange(ADXL345_RANGE_4_G);
 // displaySetRange(ADXL345_RANGE_2_G);
 
 /* Display some basic information on this sensor */
 //displaySensorDetails();
 
 /* Display additional settings (outside the scope of sensor_t) */
 /*displayDataRate();
 displayRange();*/

   Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);


  /*Firebase.setInt(firebaseData,"IOT/acceleratorx", 0);
  Firebase.setInt(firebaseData,"IOT/acceleratory", 0);
  Firebase.setString(firebaseData,"IOT/engine", "off");
  Firebase.setString(firebaseData,"IOT/lighting", "off");
  Firebase.setString(firebaseData,"IOT/up", "false");
  Firebase.setString(firebaseData,"IOT/down", "false");
  Firebase.setString(firebaseData,"IOT/left", "false");
  Firebase.setString(firebaseData,"IOT/right", "false");*/

  Firebase.setString(firebaseData,"IOT/engine", "off");
  Firebase.setString(firebaseData,"IOT/lighting", "off");

  Firebase.reconnectWiFi(true);

  
  firebaseData.setBSSLBufferSize(1024, 1024);
 firebaseData.setResponseSize(1024);
 Firebase.beginStream(firebaseData, "/IOT");
}
 bool d = false;

 bool enginecheck = false;

 bool lightingcheck = false;

 
void loop(void) 
{

  if (!Firebase.readStream(firebaseData))
  {
    Serial.println("------------------------------------");
    Serial.println("Can't read stream data...");
    Serial.println("REASON: " + firebaseData.errorReason());
    Serial.println("------------------------------------");
    Serial.println();
  }

  if (firebaseData.streamTimeout())
  {
    Serial.println("Stream timeout, resume streaming...");
    Serial.println();
  }

  if (firebaseData.streamAvailable())
  {
    if ((typestream(firebaseData) == "engine") && (datastream(firebaseData) == "on")){
      enginecheck = true;
      /*const char text[] = "engine on";
        radio.write(&text, sizeof(text));*/
        Serial.println("engine on");
    }
    if ((typestream(firebaseData) == "engine") && (datastream(firebaseData) == "off")){
      enginecheck = false;
      /*const char text[] = "engine off";
        radio.write(&text, sizeof(text));*/
        Serial.println("engine off");
    }
    if((typestream(firebaseData) == "lighting") && (datastream(firebaseData) == "on")){
      if (enginecheck) {
      lightingcheck = true;
       const char text[] = "lighting on";
        radio.write(&text, sizeof(text));
        Serial.println("lighting on");
      }
    }
    if((typestream(firebaseData) == "lighting") && (datastream(firebaseData) == "off")){
       if (enginecheck) {
      lightingcheck = false;
       const char text[] = "lighting off";
        radio.write(&text, sizeof(text));
        Serial.println("lighting off");
       }
    }
  }
 
  /*
  if (firebaseData.streamAvailable()){
    Serial.println("type: " + typestream(firebaseData)+ " value: " + datastream(firebaseData));
    if(typestream(firebaseData) == "lighting"){
        if (datastream(firebaseData) == "on"){
          lightingcheck = true;
          Serial.println("dawdg");
        }
        else {
          lightingcheck = false;
        }
      }
  }*/


  if (enginecheck){
    //Serial.println("engine start");

    /*if(lightingcheck){
      const char text[] = "lighting on";
        radio.write(&text, sizeof(text));
        Serial.println("lighting on");
    }
    else {
      const char text[] = "lighting off";
        radio.write(&text, sizeof(text));
        Serial.println("lighting off");
    }*/

 sensors_event_t event; 
 accel.getEvent(&event);
 
 Serial.print("X: "); Serial.print(event.acceleration.x); Serial.print(" ");
 Serial.print("Y: "); Serial.print(event.acceleration.y); Serial.print(" ");
 Serial.print("Z: "); Serial.print(event.acceleration.z); Serial.print(" ");Serial.println("m/s^2 ");
 float xval = event.acceleration.x;
 float yval = event.acceleration.y;
 Firebase.setFloat(firebaseData,"IOT/acceleratorx", double(int(xval*10+0.5))/10);
 Firebase.setFloat(firebaseData,"IOT/acceleratory", double(int(yval*10+0.5))/10);

  if ((xval>-1.5 && xval<2.5) && (yval>-1.5 && yval< 1.5)) //stationary or stop(transmitter parallel to ground)
  {
    Serial.println("s");
    const char text[] = "s";
    radio.write(&text, sizeof(text));
  } 
  else 
  { 
    if ((xval<-1.5)) //forward(transmitter tilted forward)
    {
      Serial.println("f");
      const char text[] = "f";
      radio.write(&text, sizeof(text));
    }
    if ((xval>2.5)) //backward(transmitter tilted backward)
    {
      Serial.println("a");
      const char text[] = "a";
      radio.write(&text, sizeof(text));
    }
    if ( yval<-1.6) //left(transmitter tilted to left)
    {
      Serial.println("l");
      const char text[] = "l";
      radio.write(&text, sizeof(text));
     }
     if ((yval>1.6))//right(transmitter tilted to right)
    {
      Serial.println("r"); 
      const char text[] = "r";
      radio.write(&text, sizeof(text));
    }
  }
  }
  //else Serial.println("engine stop");
  
 
}
String typestream (FirebaseData &data){
    FirebaseJson &json = data.jsonObject();
    String jsonStr;
    json.toString(jsonStr, true);
    size_t len = json.iteratorBegin();
    String key, value = "";
    int type = 0;
    for (size_t i = 0; i < len; i++)
    {
      json.iteratorGet(i, type, key, value);
      if (type != FirebaseJson::JSON_OBJECT)
      {
        return key;
      }
    }
    json.iteratorEnd();
}

String datastream (FirebaseData &data){
    FirebaseJson &json = data.jsonObject();
    String jsonStr;
    json.toString(jsonStr, true);
    size_t len = json.iteratorBegin();
    String key, value = "";
    int type = 0;
    for (size_t i = 0; i < len; i++)
    {
      json.iteratorGet(i, type, key, value);
      if (type != FirebaseJson::JSON_OBJECT)
      {
        return value;
      }
    }
    json.iteratorEnd();
}
