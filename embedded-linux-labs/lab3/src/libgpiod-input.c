#include <gpiod.h>
#include <stdio.h>
#include <unistd.h>
#include <time.h>
#include <math.h>    

#ifndef	CONSUMER
#define	CONSUMER	"Consumer"
#endif

int main(int argc, char **argv)
{
	char *chipname = "gpiochip0";
	unsigned int line_bot_in = 22;	// GPIO Pin #22 - plug button
	unsigned int line_led_out = 24;	// GPIO Pin #24 - output led
	int val;
	struct gpiod_chip *chip;
	struct gpiod_line *line;
	struct gpiod_chip *chipBut;
	struct gpiod_line *lineBut;
	int i, ret, retBut;

	//line_bot_in pin22
	chipBut = gpiod_chip_open_by_name(chipname);
	if (!chipBut) {
		perror("Open chip failed\n");
		goto end;
	}

	lineBut = gpiod_chip_get_line(chipBut, line_bot_in);
	if (!lineBut) {
		perror("Get line failed\n");
		goto close_chip;
	}

	retBut = gpiod_line_request_input(lineBut, CONSUMER);
	if (retBut < 0) {
		perror("Request line as input failed\n");
		goto release_line;
	}
	//system("gpioget --bias=pull-up gpiochip0 22"); //did it in terminal and it worked

	//line_led_out pin24
	chip = gpiod_chip_open_by_name(chipname);
	if (!chip)
	{
		perror("Open chip failed\n");
		goto release_line;
	}

	line = gpiod_chip_get_line(chip, line_led_out);
	if (!line)
	{
		perror("Get line failed\n");
		goto close_button_chip;
	}

	ret = gpiod_line_request_output(line, CONSUMER, 0);
	if (ret < 0)
	{
		perror("Request line as output failed\n");
		goto release_button_line;
	}

	/* Read input 20 times */
	/*for (i = 20; i > 0; i--) {
		val = gpiod_line_get_value(lineBut);
		if (val < 0) {
			perror("Read line input failed\n");
			goto release_button_line;
		}
		printf("Intput %d on line #%u\n", val, line_bot_in);
		sleep(1);
	}*/

	FILE *f;
	clock_t start_time, end_time;
	int button_press_duration_ms;

	while (true)
	{
		val = gpiod_line_get_value(lineBut);
		if (val < 0){
			perror("Read line input failed\n");
			goto release_line;
		}
		while(gpiod_line_get_value(lineBut)==1);

		// Record the start time
		start_time = clock();

		printf("Button pressed! Keep it pressed...\n");

		// Wait for the button release
		while (gpiod_line_get_value(lineBut)==0);

		// Record the end time
		end_time = clock();

		int button_press_duration_ticks = end_time - start_time;
		button_press_duration_ms = (int)((double)button_press_duration_ticks / CLOCKS_PER_SEC * 1000);

		printf("time pressed: %d ms\n", button_press_duration_ms);
		fflush(stdout);

		for(int j=0; j<(int)(button_press_duration_ms/100); j++){
			ret = gpiod_line_set_value(line, 1);
			if (ret < 0){
				perror("Failed to set line value");
				goto release_button_line;
			}
			usleep(10000);

			ret = gpiod_line_set_value(line, 0);
			if (ret < 0){
				perror("Failed to set line value");
				goto release_button_line;
			}
			usleep(90000);
		}
	}

release_button_line:
	gpiod_line_release(lineBut);
close_button_chip:
	gpiod_chip_close(chipBut);
release_line:
	gpiod_line_release(line);
close_chip:
	gpiod_chip_close(chip);
end:
	return 0;
}