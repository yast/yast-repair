#
# Makefile.am for repair/doc
#

SUBDIRS = autodocs

htmldir = @docdir@

html_DATA =

EXTRA_DIST = $(html_DATA)

API.dvi: API.tex api.tex
	latex API.tex
	latex API.tex

API.ps: API.dvi
	dvips API.dvi

API.pdf: API.ps
	ps2pdf API.ps API.pdf

