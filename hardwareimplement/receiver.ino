#include <AFMotor.h>

#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
RF24 radio(9, 10); // CE, CSN
const byte address[6] = "00001";
AF_DCMotor motor3(3);
AF_DCMotor motor2(2);
AF_DCMotor motor1(1);
AF_DCMotor motor4(4);

int led = 8;

void setup() {
  Serial.begin(9600);
  
  pinMode(led, OUTPUT);
  
  motor1.setSpeed(100); 
  motor1.run(RELEASE);
  motor2.setSpeed(100); 
  motor2.run(RELEASE);
  motor3.setSpeed(100); 
  motor3.run(RELEASE);
  motor4.setSpeed(100); 
  motor4.run(RELEASE);
  
  radio.begin();
  radio.openReadingPipe(0, address);
  radio.setPALevel(RF24_PA_MIN);
  radio.startListening();
  
}

bool lightingcheck = false;

bool enginecheck = false;

String textstring;

void loop() {
  if (radio.available()) {

    char text[32] = "";
    radio.read(&text, sizeof(text));
    Serial.print("haha ");
    Serial.println(text);
    textstring = String(text);
    
    /*if (lightingcheck) digitalWrite(led, HIGH);
  else digitalWrite(led, LOW);
    
    if ((textstring == "lighting on")){
      lightingcheck = true;
      //digitalWrite(led, HIGH);
      
    }
    if ((textstring == "lighting off")) {
       lightingcheck = false;
       //digitalWrite(led, LOW);
       
    }
    if ((textstring == "engine on")){
      enginecheck = true;
    }
     if ((textstring == "engine on")){
      enginecheck = false;
    }


 if (enginecheck){*/
    
  if (textstring == "f")
    {
      motor1.run(RELEASE);
      motor1.run(FORWARD);
      motor2.run(RELEASE);
      motor2.run(FORWARD);
      motor3.run(RELEASE);
      motor3.run(FORWARD);
      motor4.run(RELEASE);
      motor4.run(FORWARD);
    }
    if (textstring == "a")
    {
      motor1.run(RELEASE);
      motor1.run(BACKWARD);
      motor2.run(RELEASE);
      motor2.run(BACKWARD);
      motor3.run(RELEASE);
      motor3.run(BACKWARD);
      motor4.run(RELEASE);
      motor4.run(BACKWARD);
    }
    if (textstring == "s")
    {
      motor1.run(RELEASE);
      motor2.run(RELEASE);
      motor3.run(RELEASE);
      motor4.run(RELEASE);
    }
    if (textstring == "l")
    {
      motor1.run(RELEASE);
      motor1.run(FORWARD);
      motor2.run(RELEASE);
      motor2.run(FORWARD);
      motor3.run(RELEASE);
      motor3.run(FORWARD);
      motor4.run(RELEASE);
      motor4.run(BACKWARD);
    }
    if (textstring == "r")
    {
      motor1.run(RELEASE);
      motor1.run(FORWARD);
      motor2.run(RELEASE);
      motor2.run(FORWARD);
      motor3.run(RELEASE);
      motor3.run(BACKWARD);
      motor4.run(RELEASE);
      motor4.run(FORWARD);
    }
    if ((textstring == "lighting on")){
      lightingcheck = true;
      //digitalWrite(led, HIGH);
      
    }
    if ((textstring == "lighting off")) {
       lightingcheck = false;
       //digitalWrite(led, LOW);
       
    }
 }/*else {
  motor1.run(RELEASE);
     // motor1.run(FORWARD);
      motor2.run(RELEASE);
      //motor2.run(FORWARD);
      motor3.run(RELEASE);
     // motor3.run(FORWARD);
      motor4.run(RELEASE);
      //motor4.run(FORWARD);
 }*/
  
  if (lightingcheck) digitalWrite(led, HIGH);
  else digitalWrite(led, LOW);
 
}
