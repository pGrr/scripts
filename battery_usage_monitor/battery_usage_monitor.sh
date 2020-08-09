#!/bin/bash

# This script checks periodically the battery's percentage level. 
# At every check it does the following:
# - if the battery is below a given percentage and the adapter is not plugged in, it notifies
# - it prints the current time stamp, the battery percentage and the rate of (charge/discharge) 
# since last check in stdout and in a log file

# log file path
LOG=~/.battery_usage_monitor.log

# battery will be checked every DEL seconds
DEL=60

# battery percentage's lower bound (for notifications)
LOW=30

# prints the current percentage level
function percentage() {
	upower -d \
		| grep percentage \
		| head --lines=1 \
		| awk '{print $2}' \
		| tr -d '%'
}

# prints the first argument in sdout and into the log file
function printAndLog() {
	echo "$1" | tee -a $LOG
}

# if battery percentage is below LOW and adapter is not plugged in, user will be notified
function lowerBoundCheck() {
	PERC=`percentage`
	ON_BATTERY=`upower -d | grep on-battery | awk '{print $2}'`
	if [[ (( $PERC < $LOW )) && $ON_BATTERY  == 'yes' ]]; then
		notify-send -u critical -t 5000 \
			"Attention!" \
			"Battery power level is $PERC%, please plug in your AC-adapter."
	fi
}


# Never ending loop: every DEL seconds it performs the lower-bound-check and prints 
# current percentage and rate of charge/discharge into stdout and log file
export MIN=0
export PERC=-1
#rm -f $LOG
touch $LOG
printAndLog ""
printAndLog "`date` - $0 starting to monitor battery usage..."
PERC=`percentage`
printAndLog "`date` - Initial battery level is $PERC%."
echo "Waiting..."
printAndLog ""
lowerBoundCheck
sleep 60
while true; do 
	MIN=$(($MIN+1))
	NEW_PERC=`percentage`
	if (( $NEW_PERC != $PERC )); then
		DELTA_PERC=$(( $NEW_PERC - $PERC ))
		PERC=$NEW_PERC
		lowerBoundCheck
		printAndLog "`date` - Battery level is $PERC%."
		RATE=`awk "BEGIN {print $DELTA_PERC / $MIN}"`
		printAndLog "Current rate is $RATE percentage/minute."
		MIN=0
		echo "Waiting..."
		printAndLog ""
	fi
	sleep 60
done;

