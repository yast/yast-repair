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
	OSRMode.ycp		\
	OSRCommon.ycp


client_DATA = 			\
	view_anymsg.ycp		\
	inst_repair.ycp		\
	repair.ycp		\
	osr_module_list.ycp	\
	osr_verified_packages.ycp

ynclude_DATA =          		\
	osr_module_init.ycp		\
	osr_module_packages.ycp		\
	osr_module_partition.ycp	\
	osr_module_bootloader.ycp


desktop_DATA =			\
	messages.desktop	\
	bootmsg.desktop
		
	
EXTRA_DIST = $(client_DATA) $(module_DATA) $(ynclude_DATA) $(desktop_DATA)

repair:
	ln -sf . repair

ycpchook = repair

include $(top_srcdir)/Makefile.am.common
