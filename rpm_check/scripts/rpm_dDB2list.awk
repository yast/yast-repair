{if (length($0) > 0) output = $0 "," output }
END{
	output = substr(output,1,length(output)-1) # delete last char from output
	output = "[" output "]";
	print output;
}
