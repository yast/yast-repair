BEGIN{
	# define varibles for other programms that this script using
	PREFIX = ENVIRON["PREFIX"]; # PREFIX have to be an exported environment Variable
	RLS = PREFIX "/bin/rls";
	READLINK = PREFIX "/bin/readlink";
	RPM="rpm"
	MD5SUM = "md5sum";
}

# returns a void string if f_str doesn't match any known stderr-output of rpm
# TODO other stderr rpm-outputs have to be tested
function rpm_stderr_match(f_str){
	if(f_str ~ /^package .* is not installed$/)
		return f_str;
	return "";
}

# this function deletes the last character in the parameter-string
function delete_last_char(f_string){
	return substr(f_string,1, length(f_string)-1);
}

#returns parsed rpm_version in var rpm_version and rpm name as return-value
function get_rpm_name(f_rpm_name){
	rpm_version = "";
	if (match(f_rpm_name,/-[^-]*-[0-9]+$/) > 0){
		rpm_version = substr(f_rpm_name,RSTART+1,RLENGTH);
		# return f_rpm_name;
		# returns the rpm-short-name
		return substr(f_rpm_name,1,RSTART-1);
	}
	# if you want to force the rpm_version-detection and be sure thet this rpm-packge IS installed -> 
	# decomment the part "FORCE_VERSION" of following code...
	# ATTENTION!!! this is an additional rpm-call !
	
	#FORCE_VERSION_BEGIN
	#tmp = "";
	## POSSIBLE: stdout->stderr BUT string mishmash-DANGER!
	#rpm_q_command = RPM " -q " f_rpm_name " 2>&1";
	#rpm_q_command | getline tmp;
	#close(rpm_q_command); 
	#if (length(rpm_stderr_match(tmp)) < 1){
	#	f_rpm_name = tmp;
	#	if (length(f_rpm_name) > 0) return get_rpm_name(f_rpm_name);   
	#}
	#FORCE_RPMVERSION_END
	return f_rpm_name;
}

# anlysists a rpm_files_fail-string (like "")
function get_file_info( f_filename, f_rpmfail_str){
	rls_command = RLS " '" f_filename "'";
	rls_command | getline;
	close(rls_command);
	ret_str = "$[";
	if(f_rpmfail_str ~ /S/) ret_str = ret_str "\"S\":\""$11"\",";
	if(f_rpmfail_str ~ /M/) ret_str = ret_str "\"M\":\""$2"\",";
	if(f_rpmfail_str ~ /D/) ret_str = ret_str "\"D\":\""$8"\",";
	if(f_rpmfail_str ~ /U/) ret_str = ret_str "\"U\":\""$6"\",";
	if(f_rpmfail_str ~ /G/) ret_str = ret_str "\"G\":\""$7"\",";
	if(f_rpmfail_str ~ /T/) ret_str = ret_str "\"T\":\""$15"\","; # modification time
	if((f_rpmfail_str ~ /5/)||(f_rpmfail_str ~ /\?/)){ # the "?"-symbol appears if read-permission for this file isn't set
		md5sum_command = MD5SUM " \"" f_filename "\"";
		if(( md5sum_command|getline) > 0)
			ret_str = ret_str "\"5\":\""$1"\",";
		else # void string => info not accessable(permissions?)
			ret_str = ret_str "\"5\":\"""\",";
		close(md5sum_command);
	}
	if(f_rpmfail_str ~ /L/){
		readlink_command = READLINK "\"" f_filename "\"";
		readlink_command | getline tmp_linkstr;
		close(readlink_command);
		ret_str = ret_str "\"L\":\""tmp_linkstr"\",";
	}
	if(ret_str != "$[") ret_str = delete_last_char(ret_str);
	ret_str = ret_str "]";
	return ret_str;
}	

# f_rpm_filetype is "c", "d" or "l"
function create_rpm_filelist(f_rpmname, f_rpm_filetype, f_rpmfiles){ 
	delete f_rpmfiles;
	# POSSIBLE: stdout->stderr BUT string-mishmash-DANGER!
	rpm_qx_command = RPM " -q" f_rpm_filetype " " f_rpmname;
	for (cout = 0; rpm_qx_command|getline; count++)
		if (length(rpm_stderr_match(tmp)) < 1)	f_rpmfiles[count] = $0;
	close(rpm_qx_command);
	return;
}

# returns a rpm-filetype of f_rpm_filename: conf c, doc d, main l
function rpm_filetype(f_rpm_filename, f_doc_rpmfiles, f_conf_rpmfiles){
	for(item in doc_rpmfiles)
		if (f_doc_rpmfiles[item] == f_rpm_filename) return "d";
	for(item in conf_rpmfiles)
		if(f_conf_rpmfiles[item] == f_rpm_filename) return "c";
	return "l";
}

# returns a new data-string 
function add_filefails(f_filename, f_failstr, f_data_str){
	f_data_str = f_data_str "\""f_filename"\":"get_file_info(f_filename, f_failstr)",";
	return f_data_str;
}

{
	rpm_name = $0;
	rpm_version = "";
	# rpm_version will be changed after call get_rpm_name(...)
	rpm_short_name = get_rpm_name(rpm_name);
	# theoretisch ist es moeglich die Limits fuer Datentypen (len(some_string)<=3000) der awk nicht ueberfordern, 
	# ausgaben direkt ausgeben (nicht erst in strings speichern), dabei muss man auf einen korrekten stdin-stream:
	# nach Fehlertyp sortiert sein, wie es z.B. bei rpm ver3.0.6 der Fall ist.
	# main collecting varible OUTPUTstr
	OUTPUTstr="$[\"RPM_NAME\":\""rpm_name"\",\"RPM_VERSION\":\""rpm_version"\",\"RPM_SHORT_NAME\":\""rpm_short_name"\",";
	create_rpm_filelist(rpm_name, "c", conf_rpmfiles);
	create_rpm_filelist(rpm_name, "d", doc_rpmfiles);
	count_missed = 0;
	l_list = "\"l\":$[";
	c_list = "\"c\":$[";
	d_list = "\"d\":$[";
	control_length_init = length(d_list);
	req_deps_str = "";
	missed_files = "[";
	rpm_damage = "false";
	# POSSIBLE: stdout->stderr BUT mishmash-DANGER!
	rpm_V_command = RPM " -V " rpm_name " 2>&1 | cat ";
	# if the rpm-package isn't installed a void "not_damaged" map will be returned
	while((rpm_V_command | getline) > 0){
		# if some output from "rpm -V" => rpm_errors
		rpm_damage = "true";
		if($0 ~ /^Unsatisfied dependencies for /){
			# extract requirements
			# it parses rpm output if appears "Unsatisfied dependencies ..." to coma-separated file-list
			req_deps_str = $0;
			sub(/Unsatisfied dependencies for .*:/,"",req_deps_str);
			gsub(/, /,"\",\"",req_deps_str);
			sub(/^ +/,"",req_deps_str);
			sub(/^/,"\"",req_deps_str);
			sub(/ +$/,"",req_deps_str);
			sub(/$/,"\"",req_deps_str);
		}else{
			# file error
			# extract filename
			filename = substr($0, 12);
			if($0 ~ /^missing /){
				count_missed++;
				#missing_files[count_missed] = filename;
				if(count_missed > 1)
					missed_files = missed_files ",";
				missed_files = missed_files "\"" filename "\"";
			}else{
				rpm_stderr = rpm_stderr_match($0);
				if (length(rpm_stderr) < 1){
					# case of rpm_file_fail_string here
					# extract FAILS-string
					failstr = substr($0,1,9);
					filetype = rpm_filetype(filename, doc_rpmfiles, conf_rpmfiles);
					if (filetype=="l")	l_list = add_filefails(filename, failstr, l_list);
					else{
						if(filetype=="c") c_list = add_filefails(filename, failstr, c_list);
						else d_list = add_filefails(filename, failstr, d_list);
					}
				}else{
					# ... handle rpm-stderr-outputs here ...
					system("echo '<DEBUG>rpm_stat.awk: while rpm -V   a rpm-stderr-output found : "rpm_stderr "' > /dev/stderr");
				}
			}
		}
	}
	close(rpm_V_command);
	missed_files = missed_files "]";
	req_deps_str = "[" req_deps_str "]";
	# if some data added => delete the coma after the last entry
	if (control_length_init < length(l_list)) l_list = delete_last_char(l_list);
	if (control_length_init < length(c_list)) c_list = delete_last_char(c_list);
	if (control_length_init < length(d_list)) d_list = delete_last_char(d_list);
	l_list = l_list "]";
	c_list = c_list "]";
	d_list = d_list "]";
	OUTPUTstr = OUTPUTstr "\"DAMAGED\":"rpm_damage",\"DEPS_FAILS\":"req_deps_str",\"MISSED_FILES\":"missed_files",\"FILE_FAILS\":$["l_list","c_list","d_list"]]"
	print OUTPUTstr;
}
