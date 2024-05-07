import RPi.GPIO as GPIO
import paho.mqtt.client as mqtt

# Set up GPIO using BCM numbering
GPIO.setmode(GPIO.BCM)

# Define the LED GPIO pin
LED_PIN = 17 

# Set up the LED pin as output
GPIO.setup(LED_PIN, GPIO.OUT)

# MQTT settings
MQTT_BROKER = "172.27.227.201" 
MQTT_PORT = 1883 
MQTT_TOPIC = "ledController"

# Callback function for MQTT connection
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    # Subscribe to the topic when connected
    client.subscribe(MQTT_TOPIC)

# Callback function for MQTT message reception
def on_message(client, userdata, msg):
    print("Received message: "+msg.payload.decode())
    if float(msg.payload.decode()) == 1: #treshhold
        print("LED ON")
        GPIO.output(LED_PIN, GPIO.HIGH)
    else:
        print("LED OFF")
        GPIO.output(LED_PIN, GPIO.LOW)

# Create MQTT client instance
client = mqtt.Client()

# Set up MQTT callbacks
client.on_connect = on_connect
client.on_message = on_message

# Connect to MQTT broker
client.connect(MQTT_BROKER, MQTT_PORT)

# Start the MQTT loop
client.loop_forever()