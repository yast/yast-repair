// raw ls
// lists raw stat-data of a file[s]
// restrictions: the file with name "-v" will be interpreted as "verbose"-parameter
#include <cstdio>
#include <cstdio>
#include <iostream>
#include <string>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <pwd.h>
#include <grp.h>

#ifndef MAJOR
#define MINOR_BITS 8
#define MAJOR(dev) (((dev) >> MINOR_BITS) & 0xff)
#define MINOR(dev) ((dev) & 0xff)
#endif
#define INFO_STR "FileType\tFileMode(octal)\tdev\tino\tmode(full,oct)\tnlink\tuid\tgid\trdev\tmajor_num\tminor_num\tsize\tblksize\tblocks\tatime\tmtime\tctime\tFILE_NAME\n"

using namespace std;

int print_help(string myname){
	cerr << "USAGE: " << myname << " [-v] <filename[s]>\n\nOutput format:\n" INFO_STR "\n\nOPTIONS:\n\t-v\tbe verbose\n";
	exit(0);
}

int main(int argc, char** argv)
{
	int exitcode = 0;
	struct stat statv;
	if(argc < 2) print_help(argv[0]);
	argc--;
	for(int i=argc; i > 0; i--) {
		if (strcmp(argv[i], "-v") == 0){
			if(argc < 2) print_help(argv[0]);
			cout << INFO_STR;
			break;
		}
	}
	for(;argc > 0; argc--){
		if (strcmp(argv[argc], "-v") == 0){
			continue;
		}
		if (lstat(argv[argc], &statv) != 0){
			cerr << argv[0] << ": no such file or directory: " << argv[argc] << endl;
			exitcode = 1;
			continue;	
		}
		switch(statv.st_mode&S_IFMT){
			case S_IFREG: cout << '-'; break;
			case S_IFDIR: cout << 'd'; break;
			case S_IFLNK: cout << 'l'; break;
			case S_IFCHR: cout << 'c'; break;
			case S_IFBLK: cout << 'b'; break;
			case S_IFIFO: cout << 'p'; break;
		}
		cout << "\t\t";
		// permissions extract BEGIN (octal)
		cout << oct << (((1<<10) - 1) & statv.st_mode) << "\t\t";
		// permissions extract END
		// switching output to decimal
		cout << dec << statv.st_dev  << "\t";
		cout << statv.st_ino  << "\t";
		
		// here are the newer changes (rpm_stat.awk isn't corrected
		cout << oct << statv.st_mode  << dec << "\t\t";// NECESSARY to known (according to 'rpm -q --dump' outputformat
		cout << statv.st_nlink  << "\t";
		
		// try to get user- and groupnames, if failed -> prints uid & gid numbers
		// THE FUNCTIONS getgrgid and getpwuid don't works correctly here -> FIND the BUG
		// struct group *gr_p;
		// struct passwd *pw_p;
		// gr_p = getgrgid (statv.st_uid);
		// pw_p = getpwuid (statv.st_gid);
		// if (gr_p == NULL)
			cout << statv.st_uid;// else cout << gr_p->gr_name; 
		cout << '\t';
		// if (pw_p == NULL) 
			cout << statv.st_gid;// else cout << pw_p->pw_name; 
		cout << '\t';
		
		cout << statv.st_rdev  << "\t";
//		if((statv.st_mode & S_IFMT) == S_IFCHR || (statv.st_mode & S_IFMT) == S_IFBLK) 
		cout << MAJOR(statv.st_rdev) << "\t\t" << MINOR(statv.st_rdev) << "\t\t";
		cout << statv.st_size  << "\t";// NECESSARY to known
		cout << statv.st_blksize << "\t";
		cout << statv.st_blocks  << "\t";
		cout << statv.st_atime  << "\t";
		cout << statv.st_mtime  << "\t";// NECESSARY to known
		cout << statv.st_ctime << "\t";
		cout << "\t " << argv[argc] ; // filename: NECESSARY to known
		cout << endl;
	}
	return exitcode;
}
