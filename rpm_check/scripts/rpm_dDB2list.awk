# used by ag_rpm (rpm agent)
# reads rpm maps 
# RESTRICTIONS: rpm-map may not contain '#'-symbol 
BEGIN{ found = 0; printf("[ ");}
{ 
	sub(/#.*$/,"",$0); # all after '#' in a string is comment -> delete it
	if (length($0) > 0) {
		found++;
		printf("%s", prev);
		if(found > 1) printf(", ");
		prev = $0;
	}
}
END{ printf("%s]", prev); }
