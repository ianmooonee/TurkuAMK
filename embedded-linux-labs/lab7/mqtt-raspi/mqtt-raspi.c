#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "MQTTClient.h"
#include <gpiod.h>
#include <unistd.h>

#ifndef	CONSUMER
#define	CONSUMER	"Consumer"
#endif

#define ADDRESS     "tcp://172.27.227.210:1883"
#define CLIENTID    "ExampleClientPub"
#define TOPIC       "MQTT Examples"
#define PAYLOAD     "Hello World!"
#define QOS         1
#define TIMEOUT     10000L

int main(int argc, char* argv[])
{
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;
    int rc;

    MQTTClient_create(&client, ADDRESS, CLIENTID,
        MQTTCLIENT_PERSISTENCE_NONE, NULL);
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;

    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        exit(-1);
    }
    pubmsg.payload = PAYLOAD;
    pubmsg.payloadlen = strlen(PAYLOAD);
    pubmsg.qos = QOS;
    pubmsg.retained = 0;

    //GPIO configuration
    char *chipname = "gpiochip0";
	unsigned int line_num = 25;	// GPIO Pin #25
	struct timespec ts = { 1, 0 };
	struct gpiod_line_event event;
	struct gpiod_chip *chip;
	struct gpiod_line *line;
	int i, ret;

	chip = gpiod_chip_open_by_name(chipname);
	if (!chip) {
		perror("Open chip failed\n");
		ret = -1;
		goto end;
	}

	line = gpiod_chip_get_line(chip, line_num);
	if (!line) {
		perror("Get line failed\n");
		ret = -1;
		goto close_chip;
	}

	ret = gpiod_line_request_rising_edge_events(line, CONSUMER);
	if (ret < 0) {
		perror("Request event notification failed\n");
		ret = -1;
		goto release_line;
	}
    //end of configuration

    while(true){
        ret = gpiod_line_event_wait(line, &ts);
        if (ret < 0) {
            perror("Wait for event notification failed\n");
            ret = -1;
            goto release_line;
        }
        else if(ret==0){
            MQTTClient_publishMessage(client, TOPIC, &pubmsg, &token);
            printf("Waiting for up to %d seconds for publication of %s\n"
            "on topic %s for client with ClientID: %s\n",
            (int)(TIMEOUT/1000), PAYLOAD, TOPIC, CLIENTID);
            rc = MQTTClient_waitForCompletion(client, token, TIMEOUT);
            printf("Message with delivery token %d delivered\n", token);
        }
        ret = gpiod_line_event_read(line, &event);
        if (ret < 0) {
            perror("Read last event failed\n");
            ret = -1;
            goto release_line;
        }
    }

//errors
release_line:
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
	gpiod_line_release(line);
close_chip:
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
	gpiod_chip_close(chip);
end:
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
	return rc;
}