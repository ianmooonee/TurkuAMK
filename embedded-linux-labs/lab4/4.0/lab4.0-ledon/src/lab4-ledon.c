#include <gpiod.h>
#include <stdio.h>
#include <unistd.h>

#ifndef CONSUMER
#define CONSUMER "Consumer"
#endif

int main(int argc, char **argv)
{
    char *chipname = "gpiochip0";
    unsigned int line_num = 23; // GPIO Pin #23
    unsigned int val;
    struct gpiod_chip *chip;
    struct gpiod_line *line;
    int i, ret;

    chip = gpiod_chip_open_by_name(chipname);
    if (!chip) {
        perror("Open chip failed");
        return 1;
    }

    line = gpiod_chip_get_line(chip, line_num);
    if (!line) {
        perror("Get line failed");
        gpiod_chip_close(chip);
        return 2;
    }

    ret = gpiod_line_request_output(line, CONSUMER, 0);
    if (ret < 0) {
        perror("Request line as output failed");
        gpiod_line_release(line);
        gpiod_chip_close(chip);
        return 3;
    }
    
    ret = gpiod_line_set_value(line, 1);
    if (ret < 0) {
        perror("Set line output failed");
        gpiod_line_release(line);
        gpiod_chip_close(chip);
        return 4;
    }

    printf("LED is ON\n");

    gpiod_line_release(line);
    gpiod_chip_close(chip);
    return 0;
}