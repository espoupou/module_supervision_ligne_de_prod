#include <WiFi.h>
#include <PubSubClient.h>
#include <NewPing.h>

// WiFi
const char* ssid = "devipro";
const char* password = "devipro";

// MQTT
const char* mqtt_server = "192.168.27.172";
WiFiClient espClient;
PubSubClient client(espClient);

const char* mqtt_topic_ir = "produit/compte";
const char* mqtt_topic_ultrason = "produit/niveau";
const char* mqtt_topic_mc38 = "produit/rebut";
const char* mqtt_topic_reset = "processus/reset";

// Capteurs
#define PIN_IR 19
#define TRIGGER_PIN 5
#define ECHO_PIN 18
#define PIN_MC38 23
#define MAX_DISTANCE 200
#define PIN_LED_GREEN 2
#define PIN_LED_RED 2

// Capteur niveau
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

// Capteur magnétique
int etat_qualite = 0;
int dernier_etat_qualite = 0;

// Débouncing
volatile int compteur = 0;
unsigned long last_ir_time = 0;
const unsigned long debounce_delay = 300;

void IRAM_ATTR detecterObjet() {
  unsigned long current_time = millis();
  if (current_time - last_ir_time > debounce_delay) {
    compteur++;
    last_ir_time = current_time;
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  if (String(topic) == mqtt_topic_reset) {
    if (message == "reset") {
      compteur = 0;
      Serial.println("Compteur remis à zéro via MQTT");
    }
  }
}

void reconnectMQTT() {
  while (!client.connected()) {
    Serial.print("Connexion MQTT...");
    if (client.connect("nodered-client")) {
      Serial.println("connecté");
      client.subscribe(mqtt_topic_reset);
      digitalWrite(PIN_LED_GREEN, HIGH);
      digitalWrite(PIN_LED_RED, LOW);
    } else {
      Serial.print("Échec, code erreur : ");
      Serial.println(client.state());
      digitalWrite(PIN_LED_RED, HIGH);
      digitalWrite(PIN_LED_GREEN, LOW);
      delay(2000);
    }
  }
}

void setup() {
    Serial.begin(115200);
    pinMode(PIN_LED_GREEN, OUTPUT);
    pinMode(PIN_LED_RED, OUTPUT);

    digitalWrite(PIN_LED_GREEN, LOW);
    digitalWrite(PIN_LED_RED, HIGH);

    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("\nWiFi connecté");
    Serial.print("IP address: "); //192.168.27.34
    Serial.println(WiFi.localIP());

    client.setServer(mqtt_server, 1883);
    client.setCallback(callback);

    pinMode(PIN_IR, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(PIN_IR), detecterObjet, FALLING);

    pinMode(PIN_MC38, INPUT_PULLUP);
}

void loop() {
    if (!client.connected()) {
        reconnectMQTT();
    }
    client.loop();

    client.publish(mqtt_topic_ir, String(compteur).c_str());

    int distance = sonar.ping_cm();
    client.publish(mqtt_topic_ultrason, String(distance).c_str());

    etat_qualite = digitalRead(PIN_MC38);
    if (etat_qualite != dernier_etat_qualite) {
        dernier_etat_qualite = etat_qualite;
        if (etat_qualite == LOW) {
            client.publish(mqtt_topic_mc38, "1");
        }
    }

    Serial.print("Compteur IR : "); Serial.println(compteur);
    Serial.print("Distance : "); Serial.print(distance); Serial.println(" cm");
    Serial.print("État Qualité : "); Serial.println(etat_qualite);

    delay(500);
}
