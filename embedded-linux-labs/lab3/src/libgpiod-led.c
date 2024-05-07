#if 0
#include <gpiod.h>
#include <stdio.h>
#include <unistd.h>

#ifndef	CONSUMER
#define	CONSUMER	"Consumer"
#endif

int main(int argc, char **argv)
{

	char *chipname = "gpiochip0";
	unsigned int line_num = 23;	// GPIO Pin #23
	unsigned int val;
	struct gpiod_chip *chip;
	struct gpiod_line *line;
	int i, ret;

	chip = gpiod_chip_open_by_name(chipname);
	if (!chip) {
		perror("Open chip failed\n");
		goto end;
	}

	line = gpiod_chip_get_line(chip, line_num);
	if (!line) {
		perror("Get line failed\n");
		goto close_chip;
	}

	ret = gpiod_line_request_output(line, CONSUMER, 0);
	if (ret < 0) {
		perror("Request line as output failed\n");
		goto release_line;
	}

	/* Blink 20 times */
	val = 0;
	for (i = 40; i > 0; i--) { //was 20
		ret = gpiod_line_set_value(line, val);
		if (ret < 0) {
			perror("Set line output failed\n");
			goto release_line;
		}
		printf("Output %u on line #%u\n", val, line_num);
		sleep(1);
		val = !val;
	}

	//blink in and endless loop
	/*val = 0;
	while(1){
		ret = gpiod_line_set_value(line, val);
		if (ret < 0) {
			perror("Set line output failed\n");
			goto release_line;
		}
		printf("Output %u on line #%u\n", val, line_num);
		//fflush(stdout);
		//sleep(1);
		//usleep(1000);
		//usleep(1);
		val = !val;
	}*/

	//turn off led after execution
	ret = gpiod_line_set_value(line, 0);
		if (ret < 0) {
			perror("Set line output failed\n");
			goto release_line;
		}

release_line:
	gpiod_line_release(line);
close_chip:
	gpiod_chip_close(chip);
end:
	return 0;
}
#endif