/*
 * timers_init.c
 *
 *  Created on: 17 Sep 2019
 *      Author: Jarno Tuominen
 */


/* Timer initialization routines and handlers */

#include "endian.h"
#include <stdio.h>
#include <signal.h>
#include <sys/time.h>
#include <time.h>
#include <string.h> //needed by memset
#include <gpiod.h>
#include <stdbool.h>
#include <unistd.h>

#ifndef	CONSUMER
#define	CONSUMER	"Consumer"
#endif
FILE *tempfile;
bool comprobator=true;
int counter=0;
/*Let's create the global pins*/
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
int array[]={0,10000,32500,75000,140000,232500,355000,507500,675000,875500,1047500,1242500,1440000,1630000,1812500,1980000,2130000,2325000,2357500,2425000,2465000,2490000,2500000};
/**@brief Common handler for all the timers
 *
 * @details
 */
static void timerHandler( int sig, siginfo_t *si, void *uc )
{
    timer_t *tidp;
    FILE *fp;
    int val;
    int err_code;
    tidp = si->si_value.sival_ptr;
    if ( *tidp == firstTimerID ) {
    	if(comprobator){	
		tempfile=fopen("/sys/class/pwm/pwmchip0/pwm0/duty_cycle" , "w");
		fprintf(tempfile, "%d",3000000-array[counter]);
		fflush(tempfile);
		fclose(tempfile);
		counter++;
		if(counter==23){
			comprobator=false;
			counter=0;
		} 
	}else{
		tempfile=fopen("/sys/class/pwm/pwmchip0/pwm0/duty_cycle" , "w");
		fprintf(tempfile, "%d",500000+array[counter]);
		fflush(tempfile);
		fclose(tempfile); 
		counter++;
		if(counter==23){
			comprobator=true;
			counter=0;
		}
		}
    } 
     
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

    its.it_value.tv_sec = (int) expire_usec/1000000;
    its.it_value.tv_nsec = (expire_usec % 1000000) * 1000;
    its.it_interval.tv_sec = (int) interval_usec/1000000;
    its.it_interval.tv_nsec = (interval_usec % 1000000) * 1000;

    timer_settime(*timerID, 0, &its, NULL);
    return(0);
}



/**@brief Function for the Timer initialization.
 *
 * @details Initializes the timer module. Also creates application timers.
 * @todo 	Revise error handling
 */
int timers_init(void)
{
	int err_code;
	//Create some timers
	err_code = makeTimer(&firstTimerID, 50e3, 50e3); //5s
	if (err_code != 0) {
		return err_code;
 
	}
    


	return 0;
    
}
