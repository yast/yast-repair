#
# Makefile.am for y2c_osr/src
#

clientsdir = $(YAST2DIR)/clients
includedir = $(YAST2DIR)/include/osr
modulesdir = $(YAST2DIR)/modules/osr
menudir    = $(YAST2DIR)/menuentries
bindir     = $(YAST2DIR)/bin
scrdir     = $(YAST2DIR)/scrconf
yast2dir   = $(YAST2DIR)

clients_DATA =				\
	osr.ycp				\
	osr_start.ycp			\
	osr_module_list.ycp		\
	osr_module_init.ycp		\
	osr_module_partition.ycp	\
	osr_module_lilo.ycp

include_DATA =				\
	osr_system.ycp			\
	osr_api.ycp			\
	osr_popup.ycp			\
	osr_summary.ycp#         	\
	#osr_global_progress.ycp		\
	#osr_module_progress.ycp		\
	#osr_log_file.ycp

modules_DATA =				\
	OSRModuleProgress.ycp		\
	OSRGlobalProgress.ycp		\
	OSRLogFile.ycp

menu_DATA = 				\
	menuentry_osr.ycp

scr_DATA =				\
	etc_liloconf1.scr

##yast2_DATA =				\
#	osr_module_list.ycp

EXTRA_DIST = 				\
	$(clients_DATA) 		\
	$(include_DATA) 		\
	$(modules_DATA)			\
	$(menu_DATA) 			\
	$(scr_DATA)##			\
##	$(yast2_DATA)
