{
	list = $0;
	list = substr(list,2,length(list)-2);
	# '"'-symbol in list-elements  have to be shaded: '\"'.
	# change '\"' to '\7' (ASCII-sound), then delete all "real" 
	# '"'-symbols, then restore all '\"'
	gsub(/\\"/,"\7",list);
	if (gsub(/"/,"",list) <= 0) exit 3;
	gsub(/\7/,"\\\"",list);
	n = split(list, array, ",");
	if (n <= 0) exit 2;
	print list;
	for(i=1;i<=n;++i)
		print i ") " array[i];
}
