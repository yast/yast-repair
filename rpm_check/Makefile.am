SUBDIRS = C_src

CURR_DIR = `/bin/pwd`
RPM_STAT = scripts/rpm_stat.awk
GET_PACKAGENAMES = scripts/get_packagenames.awk
RPM_dDB2LIST = scripts/rpm_dDB2list.awk
RPM_SCR = scripts/rpm.scr
RLS = C_src/rls

YAST2_DIR = /tmp/yast2 #/usr/lib/YaST2/

#install: # $(RLS)
#installcheck:
#install-data-recursive:
#install:
#install-recursive:
#install-data: 
all-redirect: target_dirs # $(RLS)
	echo ">>>>>>>>>>>>> HERE <<<<<<<<<<<<<<<<<<"
	cp -v $(CURR_DIR)/$(RLS) $(YAST2_DIR)
	cp -v $(CURR_DIR)/$(RPM_SCR) $(YAST2_DIR)
	cp -v $(CURR_DIR)/$(RPM_dDB2LIST) $(YAST2_DIR)
	cp -v $(CURR_DIR)/$(GET_PACKAGENAMES) $(YAST2_DIR)
	cp -v $(CURR_DIR)/$(RPM_STAT) $(YAST2_DIR)

target_dirs:
	test -d $(YAST2_DIR) || mkdir $(YAST2_DIR)
