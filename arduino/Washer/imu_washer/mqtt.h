#include "ESP32MQTTClient.h"
// Test Mosquitto server, see: https://test.mosquitto.org
char *server = "mqtt://172.31.123.129:1883";
char *publishTopic = "laundry/vibration";
char *subscribeTopic = "not_used";

ESP32MQTTClient mqttClient; // all params are set later

void setup_mqtt() {
    mqttClient.enableDebuggingMessages();
    mqttClient.setURI(server);
    mqttClient.enableLastWillMessage("lwt", "I am going offline");
    mqttClient.setKeepAlive(30);
    mqttClient.loopStart();
}

void handleMQTT(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data){
  auto *event = static_cast<esp_mqtt_event_handle_t>(event_data);
  mqttClient.onEventCallback(event);
}

void onMqttConnect(esp_mqtt_client_handle_t client)
{
    if (mqttClient.isMyTurn(client)) // can be omitted if only one client
    {
        mqttClient.subscribe(subscribeTopic, [](const String &payload)
                             { log_i("%s: %s", subscribeTopic, payload.c_str()); });

        mqttClient.subscribe("bar/#", [](const String &topic, const String &payload)
                             { log_i("%s: %s", topic, payload.c_str()); });
    }
}
