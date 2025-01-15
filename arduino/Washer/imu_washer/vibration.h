#include <WiFi.h>
#include <PubSubClient.h>
#include "esp_eap_client.h"

long vib;
int vibr_Pin = 16;

void get_vib_readings(){
  Serial.println("Getting vibration reading.");
  long vibration = pulseIn (vibr_Pin, HIGH);  //wait for the pin to get HIGH and returns measurement
  vib = vibration;
  Serial.print("Vibration reading: ");
  Serial.println(vibration);
}

