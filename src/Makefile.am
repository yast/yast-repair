#
# Makefile.am for repair/src
#

yncludedir = @yncludedir@/repair

module_DATA =			\
	OSRModuleLoading.ycp	\
	OSRProgress.ycp		\
	OSRFloppy.ycp		\
	OSRBoot.ycp		\
	OSRSwap.ycp		\
	OSRFsck.ycp		\
	OSRFstab.ycp		\
	OSRPtbl.ycp		\
	OSRExecute.ycp		\
	OSRSummary.ycp		\
	OSRDirect.ycp		\
	OSRStatus.ycp		\
	OSRLogFile.ycp		\
	OSRRepairUI.ycp		\
	OSR.ycp			\
	OSRPkg.ycp		\
	OSRPkgUI.ycp		\
	OSRPkgVerify.ycp	\
	OSRPopup.ycp		\
	OSRSystem.ycp		\
	OSRMode.ycp


client_DATA = 			\
	installation.ycp	\
	inst_language.ycp	\
	inst_custom_part.ycp	\
	inst_repair.ycp		\
	repair.ycp		\
	osr_module_init.ycp	\
	osr_module_list.ycp	\
	osr_module_packages.ycp	\
	osr_module_partition.ycp\
	osr_minimal.ycp		\
	osr_verified_packages.ycp	\
	osr_module_bootloader.ycp

config_DATA =			\
	menuentry_osr.y2cc

EXTRA_DIST = $(client_DATA) $(config_DATA) $(module_DATA)
