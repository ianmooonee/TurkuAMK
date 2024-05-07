/*
 * timers_init.c
 *
 *  Created on: 17 Sep 2019
 *      Author: Jarno Tuominen
 */


/* Timer initialization routines and handlers */

#include <stdio.h>
#include <signal.h>
#include <sys/time.h>
#include <time.h>
#include <string.h> //needed by memset
#include <gpiod.h>

#ifndef	CONSUMER
#define	CONSUMER	"Consumer"
#endif

struct gpiod_chip *chip;
struct gpiod_line *line;
int i, ret;
struct gpiod_chip *chip2;
struct gpiod_line *line2;
int ret2;

/* Let's create the global timer objects */
timer_t firstTimerID;
timer_t secondTimerID;
timer_t thirdTimerID;
timer_t pwdTimerID;
static int makeTimer(timer_t *timerID, int expire_usec, int interval_usec );

/**@brief Common handler for all the timers
 *
 * @details
 */
static void timerHandler( int sig, siginfo_t *si, void *uc )
{
    timer_t *tidp;
    FILE *fp;
    int err_code, ret1;
    tidp = si->si_value.sival_ptr;
    fp=fopen("/home/pi/timers.log","a");
    if ( *tidp == firstTimerID ) {
    	fprintf (fp, "Timer 1 says hello!\n");
    } else if ( *tidp == secondTimerID ) {
    	fprintf (fp, "Timer 2 says hello!\n");
    } else if ( *tidp == thirdTimerID ) {
    	fprintf (fp, "Timer 3 says hello!\n");
        ret2 = gpiod_line_set_value(line2, 1);
        err_code = makeTimer(&pwdTimerID, 1500, 0); //1.5ms
    } else if ( *tidp == pwdTimerID) {
		ret2 = gpiod_line_set_value(line2, 0);
    } 
    fclose(fp);
}


/**@brief Function for creating a timer
 *
 * @details
 */
static int makeTimer(timer_t *timerID, int expire_usec, int interval_usec )
{
    struct sigevent         te;
    struct itimerspec       its;
    struct sigaction        sa;
    int sigNo = SIGRTMIN;

    /* Set up signal handler. */
    sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = timerHandler;
    sigemptyset(&sa.sa_mask);

    if (sigaction(sigNo, &sa, NULL) == -1) {
        printf ("Failed to setup signal handling for timer\n");

        return(-1);
    }

    /* Set and enable alarm */
    te.sigev_notify = SIGEV_SIGNAL;
    te.sigev_signo = sigNo;
    te.sigev_value.sival_ptr = timerID;
    timer_create(CLOCK_REALTIME, &te, timerID);

    // Adjusting calculations for microseconds
    its.it_value.tv_sec = (int) (expire_usec / 1000000); // Convert microseconds to seconds
    its.it_value.tv_nsec = (expire_usec % 1000000) * 1000; // Convert remaining microseconds to nanoseconds
    its.it_interval.tv_sec = (int) (interval_usec / 1000000); // Convert microseconds to seconds for interval
    its.it_interval.tv_nsec = (interval_usec % 1000000) * 1000; // Convert remaining microseconds to nanoseconds for interval

    timer_settime(*timerID, 0, &its, NULL);
    return(0);
}

static int initChip(){
    char *chipname = "gpiochip0";
	unsigned int line_num2 = 23; //output pin

    //pin 23 - output
	chip2 = gpiod_chip_open_by_name(chipname);
	if (!chip2) {
		perror("Open chip failed\n");
		return 0;
	}

	line2 = gpiod_chip_get_line(chip2, line_num2);
	if (!line2) {
		perror("Get line failed\n");
		gpiod_chip_close(chip);
        return 0;
	}

	ret2 = gpiod_line_request_output(line2, CONSUMER, 0);
	if (ret2 < 0) {
		perror("Request line as output failed\n");
		gpiod_line_release(line);
        gpiod_chip_close(chip);
        return 0;
	}			
    return 0;
}



/**@brief Function for the Timer initialization.
 *
 * @details Initializes the timer module. Also creates application timers.
 * @todo 	Revise error handling
 */
int timers_init(void)
{
    int err_code;

    initChip();

    //Create some timers
    err_code = makeTimer(&firstTimerID, 5e6, 5e6); //5s converted to microseconds
    if (err_code != 0) {
        return err_code;
    }
    err_code = makeTimer(&secondTimerID, 3e6, 3e6); //3s converted to microseconds
    if (err_code != 0) {
            return err_code;
    }
    /*err_code = makeTimer(&thirdTimerID, 15e6, 15e6); //15s converted to microseconds
    if (err_code != 0) {
            return err_code;
    }*/
    err_code = makeTimer(&thirdTimerID, 20e3, 20e3); //20ms
	if (err_code != 0) {
			return err_code;

	}

    return 0;

}