#! /usr/bin/env -S awk -f 

function abs(number) {
    if (number < 0) 
        return -1 * number
    return number 
}

function as_seconds(decimal_hours) {
	return decimal_hours * seconds_per_hour
}

function minutes(decimal_hours) {
    return int(abs((decimal_hours - int(decimal_hours)) * mins_per_hour))
}

function to_hours_minutes(decimal_hours) {
	return sprintf("%s%d hours, %d minutes", 
		decimal_hours < 0 ? "-" : "",
        abs(int(decimal_hours)),
        minutes(decimal_hours))	
}

BEGIN {
	work_hours = 8
	mins_per_hour = 60
	seconds_per_hour = 3600
	today_start = ENVIRON["TODAY_START"]
	worked_today = ENVIRON["WORKED_TODAY"]
	if (worked_today ~ /m$/) { worked_today = worked_today / mins_per_hour }
	if (worked_today ~ /s$/) { worked_today = worked_today / seconds_per_hour }
}

END {
	to_work_8h = work_hours - worked_today
	overtime = $6 - worked_today - (work_hours * (NR-1))
	to_work = to_work_8h - overtime
    printf("Average number of hours worked per workday: = %g\n", $6/NR)
    printf("Number of days worked: = %d\n", NR)
    printf("Cummulative overtime per yersterday: = %s\n", to_hours_minutes(overtime))
	printf("Worked today: = %s\n", to_hours_minutes(worked_today))
	printf("Still to work (8hrs): = %s\n", to_hours_minutes(to_work_8h))
	printf("Still to work: = %s\n", to_hours_minutes(to_work))
	printf("Time to leave (8hrs): = %s\n", strftime("%T", mktime(today_start) + as_seconds(to_work_8h)))
	printf("Time to leave: = %s\n", strftime("%T", mktime(today_start) + as_seconds(to_work)))
}
