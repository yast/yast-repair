# on stdin have to be attached the stream from common.pkd 
BEGIN{
	bool_section_begins = 0;
	count = 0;
	# the min_file_name -variable must be specified by calling programm (awk's option -v <var_name>=<value>)
	# min_file_name - file MUST exists, otherwise it results endless loop 
	while(getline < min_file_name ){
		if( $0 ~ /^Llatsniot:/)
			bool_section_begins = 0;
		else{
											# exclude comments
			if ((bool_section_begins == 1) && ($0 !~ /^ *#/)){
				min_rpms[$0] = 0; # save rpm_names as keys and the dummy-value 0
				count++;
			}else
				if( $0 ~ /^Toinstall:/) bool_section_begins = 1;
		}
	}
	if (count == 0) { #ERROR: no one package found
		print "get_packagenames.awk: ERROR: NO rpm names in file "min_rpms" found !!! " > "/dev/stderr";
		exit 2;
	}
}

match($0, /^Filename: */) > 0 {
	rpm_name = substr($0, RSTART+RLENGTH, length($0)-(RSTART+RLENGTH-1));
	# match for a rpm-package (.rpm - extension)
	if( rpm_name ~ /\.rpm *$/){
		sub(/\.rpm */, "", rpm_name);
		if( rpm_name in min_rpms){
			print rpm_name ;
		}
	}
}
