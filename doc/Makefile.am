#
# Makefile.am for y2c_osr/doc
#

SUBDIRS = autodocs

docdir = @DOCDIR@
htmldir = $(docdir)

html_DATA =

EXTRA_DIST = $(html_DATA)

API.dvi: API.tex api.tex
	latex API.tex
	latex API.tex

API.ps: API.dvi
	dvips API.dvi

API.pdf: API.ps
	ps2pdf API.ps API.pdf

