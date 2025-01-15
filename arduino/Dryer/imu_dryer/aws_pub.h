#include "Arduino.h"
#include <WiFi.h>
#include <HTTPClient.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include <time.h>
#include <key.h>

#if __has_include("esp_eap_client.h")
#include "esp_eap_client.h"
#else
#include "esp_wpa2.h"
#endif

const char *ssid = "NUS_STU";  // Eduroam SSID
int counter = 0;

char vibrationTopic[] = "laundry/vibration";  // Topic to publish sensor data to
char gyroTopic[] = "laundry/gyro";  // Topic to publish sensor data to
char accelerationTopic[] = "laundry/acceleration";  // Topic to publish sensor data to

// AWS IoT credentials
const char* aws_endpoint = "ap9dul9m9yrmt-ats.iot.ap-southeast-1.amazonaws.com";  // AWS IoT Core endpoint
const int port = 8883;  // AWS IoT MQTT port`w

WiFiClientSecure net;
PubSubClient client(net);


// NTP server setup
const char* ntpServer = "pool.ntp.org";
const long  gmtOffset_sec = 8 * 3600;  // Singapore timezone
const int   daylightOffset_sec = 0;

void network_conf() {
  Serial.println("Connecting to network: ");
  Serial.println(ssid);
  WiFi.disconnect(true);  //disconnect form wifi to set new wifi connection
  WiFi.mode(WIFI_STA);    //init wifi mode
  esp_eap_client_set_identity((uint8_t *)EAP_IDENTITY, strlen(EAP_IDENTITY));  //provide identity
  esp_eap_client_set_username((uint8_t *)EAP_IDENTITY, strlen(EAP_IDENTITY));  //provide username
  esp_eap_client_set_password((uint8_t *)EAP_PASSWORD, strlen(EAP_PASSWORD));  //provide password
  esp_wifi_sta_enterprise_enable();

  WiFi.begin(ssid);  //connect to wifi
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    counter++;
    if (counter >= 60) {  //after 30 seconds timeout - reset board
      ESP.restart();
    }
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address set: ");
  Serial.println(WiFi.localIP());  //print LAN IP
}

// Connect to AWS IoT Core
void connectAWS() {
  net.setCACert(amazon_root_ca);
  net.setCertificate(certificate_pem_crt);
  net.setPrivateKey(private_pem_key);

  client.setServer(aws_endpoint, port);

  while (!client.connected()) {
    Serial.print("Connecting to AWS IoT Core...");
    if (client.connect("ESP32Client")) {
      Serial.println("Connected to AWS IoT Core!");
    } else {
      Serial.print("Failed, rc=");
      Serial.println(client.state());
      delay(2000);
    }
  }
}

// Function to get the current time
String getFormattedTime() {
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println("Failed to obtain time");
    return "";
  }
  char buffer[30];
  strftime(buffer, sizeof(buffer), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);
  return String(buffer);
}

void publish_res(int vibration) {
  String timestamp_value = getFormattedTime();
  String msg = String("{\"device_id\":\"ESP32_1\", \"machine_id\":\"RVREB-D1\", \"vibration\":") + vibration + ", \"timestamp_value\":\"" + timestamp_value + "\"}";
  client.publish(vibrationTopic, msg.c_str());
  Serial.println(msg);
}

void setup_wifi() {
  if (WiFi.status() == WL_CONNECTED) {  //if we are connected to Eduroam network
    counter = 0;                        //reset counter
    Serial.println("Wifi is still connected with IP: ");
    Serial.println(WiFi.localIP());            //inform user about his IP address
  } else if (WiFi.status() != WL_CONNECTED) {  //if we lost connection, retry
    WiFi.begin(ssid);
  }
  while (WiFi.status() != WL_CONNECTED) {  //during lost connection, print dots
    delay(500);
    Serial.print(".");
    counter++;
    if (counter >= 60) {  //30 seconds timeout - reset board
      ESP.restart();
    }
  }
}
