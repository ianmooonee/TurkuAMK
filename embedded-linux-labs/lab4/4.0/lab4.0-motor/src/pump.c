#include <gpiod.h>
#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>

#ifndef	CONSUMER
#define	CONSUMER	"Consumer"
#endif

int main(int argc, char **argv)
{
	char *chipname = "gpiochip0";
	unsigned int line_num = 24;	//input pin
	unsigned int line_num2 = 23; //output pin
	int val;
	struct gpiod_chip *chip;
	struct gpiod_line *line;
	int i, ret;
	struct gpiod_chip *chip2;
	struct gpiod_line *line2;
	int ret2;

    //pin 24 - input
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

	ret = gpiod_line_request_input(line, CONSUMER);
	if (ret < 0) {
		perror("Request line as input failed\n");
		goto release_line;
	}

    //pin 23 - output
	chip2 = gpiod_chip_open_by_name(chipname);
	if (!chip2) {
		perror("Open chip failed\n");
		goto end;
	}

	line2 = gpiod_chip_get_line(chip2, line_num2);
	if (!line2) {
		perror("Get line failed\n");
		goto close_chip;
	}

	ret2 = gpiod_line_request_output(line2, CONSUMER, 0);
	if (ret2 < 0) {
		perror("Request line as output failed\n");
		goto release_line;
	}

	int counter=0;
	int counter2=0;		
	
	val = gpiod_line_get_value(line);
	if (val < 0) {
		perror("Read line input failed\n");
		goto release_line;
	}
	else if(val==0){
        printf("Ligou o motor!\n");
        fflush(stdout);
		ret2 = gpiod_line_set_value(line2, 1);
	}
	else{
        printf("Desligou o motor!\n");
        fflush(stdout);
		ret2 = gpiod_line_set_value(line2, 0);
	}

release_line:
	gpiod_line_release(line);
close_chip:
	gpiod_chip_close(chip);
end:
	return 0;
}
