#returns parsed rpm_version in var rpm_version and rpm name as return-value
function get_rpm_name(f_rpm_name){
	rpm_version = "";
	tmp = "";
#	# POSSIBLE: stdout->stderr BUT string mishmash-DANGER!
#	rpm_q_command = RPM " -q " f_rpm_name " ";
#	rpm_q_command | getline tmp;
#	close(rpm_q_command); 
#	if (length(tmp) < 1){ 
#		#not installed
#		return "nil";
#	}
	if (match(f_rpm_name,/-[^-]*-[0-9]+$/) > 0){
		rpm_version = substr(f_rpm_name,RSTART+1,RLENGTH);
		# return f_rpm_name;
		# returns the rpm-short-name
		return substr(f_rpm_name,1,RSTART-1);
	}
	return f_rpm_name;
}
{
	rpm_name = $0;
	print get_rpm_name(rpm_name);
}

