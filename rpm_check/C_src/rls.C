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
#define INFO_STR "FileType\tFileMode(octal)\tdev\tino\tnlink\tuid\tgid\trdev\tmajor_num\tminor_num\tsize\tblksize\tblocks\tatime\tmtime\tctime\tFILE_NAME\n"

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
		// fieltype extract BEGIN
		// cout << (statv.st_mode & S_IFMT) << "\t";
		switch(statv.st_mode&S_IFMT){
			case S_IFREG: cout << '-'; break;
			case S_IFDIR: cout << 'd'; break;
			case S_IFLNK: cout << 'l'; break;
			case S_IFCHR: cout << 'c'; break;
			case S_IFBLK: cout << 'b'; break;
			case S_IFIFO: cout << 'p'; break;
		}
		cout << "\t\t";
		// fileytpe extract END
		// permissions extract BEGIN (octal)
		cout << oct << (((1<<9) - 1) & statv.st_mode) << "\t\t";
		// permissions extract END
		// switching output to decimal
		cout << dec << statv.st_dev  << "\t";
		cout << statv.st_ino  << "\t";
//		cout << statv.st_mode  << "\t";
		cout << statv.st_nlink  << "\t";
		cout << statv.st_uid  << "\t";
		cout << statv.st_gid << "\t";
		cout << statv.st_rdev  << "\t";
//		if((statv.st_mode & S_IFMT) == S_IFCHR || (statv.st_mode & S_IFMT) == S_IFBLK) 
		// if a device -> MINOR & MAJOR numbers
		cout << MAJOR(statv.st_rdev) << "\t\t" << MINOR(statv.st_rdev) << "\t\t";
		cout << statv.st_size  << "\t";
		cout << statv.st_blksize << "\t";
		cout << statv.st_blocks  << "\t";
		cout << statv.st_atime  << "\t";
		cout << statv.st_mtime  << "\t";
		cout << statv.st_ctime << "\t";
		cout << "\t " << argv[argc] ;
		cout << endl;
	}
	return exitcode;
}
