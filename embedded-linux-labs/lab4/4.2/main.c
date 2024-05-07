/*
 * main.c
 *
 *  Created on: 17 Sep 2019
 *      Author: Jarno Tuominen
 */


#include "timers_init.h"
#include <stdio.h> //Needed for fprintf
#include <unistd.h> //needed for sleep

int main(void)
{


	FILE *tempfile;
	int cont=0;
	cont++;
	tempfile=fopen("/sys/class/pwm/pwmchip0/export" , "w");
	fprintf(tempfile, "%d",0);
	fclose(tempfile);
	tempfile=fopen("/sys/class/pwm/pwmchip0/pwm0/period" , "w");
	fprintf(tempfile, "%d",20000000);
	fclose(tempfile);
	tempfile=fopen("/sys/class/pwm/pwmchip0/pwm0/enable" , "w");
	fprintf(tempfile, "%d",1);
	fclose(tempfile);
	int array[]={0,10000,32500,75000,140000,232500,355000,507500,675000,875500,1047500,1242500,1440000,1630000,1812500,1980000,2130000,2325000,2357500,2425000,2465000,2490000,2500000};

	int err_code;	err_code = timers_init();
	while(1){
		sleep(1);
	}
	return err_code;
}