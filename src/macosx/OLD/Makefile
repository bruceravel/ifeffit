# This is an AUTOMATICALLY configured Makefile 
# running configure will OVERWRITE this file!!!

#installation prefix
prefix        = /sw
# where pgplot library?
PG_DIR        = /sw/lib/pgplot

# how do I link with Xlib?
X_LIBS        = -L/usr/X11R6/lib -lX11 -framework Foundation -framework AppKit

# set the load library flags (perl 5.8.0 specific??)
LDDLFLAGS_P5  = -flat_namespace -bundle -undefined suppress -L/usr/local/lib -framework Foundation -framework AppKit
# set readline flags
READLINE_LIBS = -L/usr/lib/ -L/sw/lib/ -lreadline -lncurses

#<<Makefile.in>>
#
# On some systems, this should be
#       -lreadline  -lncurses
READLINE_FLAG = 
# READLINE_LIBS = -L$(prefix)/lib -L/usr/lib -lreadline
# 
# On other systems, a very old readline is installed,
# please read the 'README.Readline' file, build readline,
# and use
#{
# prefix       = /usr/local
# READLINE_FLAG = -DMY_READLINE
# READLINE_LIBS = ../../readline/libreadline.a -ltermcap
#}

# how do I link to PGPLOT?
# this assumes PGPLOT uses png and X drivers
PGPLOT_LIBS   = -L$(PG_DIR) -lpgplot \
	-L/usr/lib -L$(prefix)/lib -lpng  $(X_LIBS)


# where are the include files (esp for readline)?
INCLUDES      = -I$(srcdir) -I$(prefix)/include \
	-I/usr/include -I/usr/local/include 

# how do I compile and link with C?
CC            = cc
CFLAGS        = -O2
COMPILE       = $(CC) $(INCLUDES)  $(CFLAGS) $(READLINE_FLAG)
LINK          = $(CC) $(CFLAGS)  -o $@

# how do I compile and link with Fortran?
F77           = g77
FFLAGS        = -O2
FLIBS         = -lg2c -lm

# REDHAT 8.0 / gcc 3.2
# FLIBS         = -L/usr/lib/gcc-lib/i386-redhat-linux/3.2 -L/usr/lib/gcc-lib/i386-redhat-linux/3.2/../../.. -lfrtbegin -lg2c -lm -lgcc_s


F77LINK       = $(F77) $(FFLAGS)  -o $@


# how do I build and deal with libraries?
AR            = ar
RANLIB        = ranlib

# where is the shell?
SHELL         = /bin/sh

# installation directories relative to PREFIX
bindir        = ${prefix}/bin
pkgdatadir    = ${prefix}/share/ifeffit
libdir        = ${prefix}/lib

##################################################
#
# you shouldn't have to edit much below this
#

top_srcdir    = ../..
srcdir        = ../lib
cmndline_dir  = ../cmdline
autobk_dir    = ../autobk
feffit_dir    = ../feffit
diffkk_dir    = ../diffkk
feff6_dir     = ../feff6

all_src_dirs  = $(srcdir) $(cmndline_dir) \
	$(autobk_dir) $(feffit_dir) $(diffkk_dir) $(feff6_dir)

IFF_CONFIG    = ./configure
SYS_H         = $(srcdir)/sys.h
MAXPTS_H      = $(srcdir)/maxpts.h
HEADERS       = $(SYS_H) $(MAXPTS_H)

mkinstalldirs = $(SHELL) ../../mkinstalldirs
SET_DIR_PERM  = chmod 775

INSTALL       = /usr/bin/install -c
INSTALL_EXE   = ${INSTALL} -m 775
INSTALL_DATA  = ${INSTALL} -m 664

MN_FLIBS         = $(FLIBS)
CONFIG_TEMPLATES = Config.mak Makefile.PL site_install.py
MISC_CONFIG      = ifeffit.inc ifeffit.h  
pkgconfig_DATA   = $(CONFIG_TEMPLATES) $(MISC_CONFIG)
pkgdata_DATA     = startup.iff README

LIBRARIES     = libifeffit.a libxafs.a
#EXE          = ifeffit autobk diffkk feffit feff6
EXE           = ifeffit autobk diffkk feffit feff6

all: $(HEADERS) $(LIBRARIES) $(EXE) $(CONFIG_TEMPLATES)

XAFS_OBJ = $(srcdir)/str.o $(srcdir)/kkmclr.o $(srcdir)/fftpack.o \
	$(srcdir)/conv_lor.o $(srcdir)/specfun.o $(srcdir)/padlib.o \
	$(srcdir)/sort2.o $(srcdir)/preedg.o $(srcdir)/clbfun.o \
	$(srcdir)/minpack.o $(srcdir)/spline.o $(srcdir)/splfun.o \
	$(srcdir)/bvalue.o $(srcdir)/fitfft.o $(srcdir)/xafsft.o \
	$(srcdir)/window.o $(srcdir)/fitfun.o $(srcdir)/genfun.o \
	$(srcdir)/fiterr.o $(srcdir)/misc_num.o $(srcdir)/iread.o \
	$(srcdir)/misc_io.o $(srcdir)/compat.o $(srcdir)/inpout.o \
	$(srcdir)/uwxrdf.o $(srcdir)/chiout.o $(srcdir)/rdffdt.o

IFF_OBJ = $(srcdir)/ifeffit.o $(srcdir)/cifeffit.o $(srcdir)/str.o \
	$(srcdir)/misc_vars.o $(srcdir)/isamac.o $(srcdir)/iff_load.o \
	$(srcdir)/iread.o $(srcdir)/echo.o $(srcdir)/misc_io.o \
	$(srcdir)/iff_save.o $(srcdir)/iff_eval.o $(srcdir)/misc_arr.o \
	$(srcdir)/iff_erase.o $(srcdir)/iff_sync.o $(srcdir)/decod.o \
	$(srcdir)/enlib.o $(srcdir)/sigms.o $(srcdir)/u2ipth.o \
	$(srcdir)/kkmclr.o $(srcdir)/fftpack.o $(srcdir)/misc_num.o \
	$(srcdir)/conv_lor.o $(srcdir)/specfun.o $(srcdir)/encod.o \
	$(srcdir)/padlib.o $(srcdir)/iff_set.o $(srcdir)/iff_init.o \
	$(srcdir)/iff_plot_init.o $(srcdir)/iff_config.o \
	$(srcdir)/iff_get_line.o $(srcdir)/iff_macro.o $(srcdir)/iff_done.o \
	$(srcdir)/iff_history.o $(srcdir)/iff_test.o $(srcdir)/sort2.o \
	$(srcdir)/iff_rddata.o $(srcdir)/iff_wrdata.o $(srcdir)/iff_log.o \
	$(srcdir)/iff_show.o $(srcdir)/iff_color.o $(srcdir)/iff_correl.o \
	$(srcdir)/sum_paths.o $(srcdir)/chipth.o $(srcdir)/fefinp.o \
	$(srcdir)/rdffdt.o $(srcdir)/iff_print.o $(srcdir)/iff_echo.o \
	$(srcdir)/iff_rename.o $(srcdir)/iff_pre_edge.o $(srcdir)/preedg.o \
	$(srcdir)/iff_bkg_cl.o $(srcdir)/clcalc.o $(srcdir)/clbfun.o \
	$(srcdir)/minpack.o $(srcdir)/iff_spline.o $(srcdir)/spline.o \
	$(srcdir)/splfun.o $(srcdir)/bvalue.o $(srcdir)/fitfft.o \
	$(srcdir)/xafsft.o $(srcdir)/window.o $(srcdir)/iff_fft.o \
	$(srcdir)/iff_path.o $(srcdir)/iff_getpath.o $(srcdir)/iff_ff2chi.o \
	$(srcdir)/iff_feffit.o $(srcdir)/fitfun.o $(srcdir)/iff_chieps.o \
	$(srcdir)/fiterr.o $(srcdir)/iff_f1f2.o $(srcdir)/iff_diffkk.o \
	$(srcdir)/iff_minimize.o $(srcdir)/genfun.o $(srcdir)/iff_uncert.o \
	$(srcdir)/iff_plot.o $(srcdir)/iff_cursor.o $(srcdir)/feff_tables.o \
	$(srcdir)/iff_unguess.o $(srcdir)/iff_window.o $(srcdir)/atomic.o


lib_OBJECTS     = $(IFF_OBJ) $(srcdir)/ifeffitc.o

ifeffit_OBJECTS = $(cmndline_dir)/iff_shell.o


autobk_OBJECTS = $(autobk_dir)/autobk.o $(autobk_dir)/misc_file.o \
	$(autobk_dir)/setsys.o $(autobk_dir)/autint.o $(autobk_dir)/autinp.o \
	$(autobk_dir)/getcom.o $(autobk_dir)/autdat.o $(autobk_dir)/autnls.o \
	$(autobk_dir)/autfun.o $(autobk_dir)/autlog.o $(autobk_dir)/autout.o

feffit_OBJECTS = $(feffit_dir)/feffit.o $(feffit_dir)/setsys.o \
	$(feffit_dir)/messag.o $(feffit_dir)/fitint.o $(feffit_dir)/fitinp.o \
	$(feffit_dir)/getcom.o $(feffit_dir)/openfl.o $(feffit_dir)/nxtunt.o \
	$(feffit_dir)/getfln.o $(feffit_dir)/fixstr.o $(feffit_dir)/finmsg.o \
	$(feffit_dir)/append.o $(feffit_dir)/misc.o   $(feffit_dir)/testrf.o \
	$(feffit_dir)/filrec.o $(feffit_dir)/encod.o  $(feffit_dir)/enlib.o  \
	$(feffit_dir)/nbrstr.o $(feffit_dir)/fitdat.o $(feffit_dir)/fitchk.o \
	$(feffit_dir)/chipth.o $(feffit_dir)/fixicd.o $(feffit_dir)/setval.o \
	$(feffit_dir)/eval.o   $(feffit_dir)/decod.o  $(feffit_dir)/cordby.o \
	$(feffit_dir)/sigms.o  $(feffit_dir)/fefsrt.o $(feffit_dir)/fefinp.o \
	$(feffit_dir)/rdffdt.o $(feffit_dir)/rdfb1.o  $(feffit_dir)/fitck2.o \
	$(feffit_dir)/fitnls.o $(feffit_dir)/fitfun.o $(feffit_dir)/fitlog.o \
	$(feffit_dir)/fitprm.o $(feffit_dir)/wrtprm.o $(feffit_dir)/fitout.o \
	$(feffit_dir)/xfsout.o


diffkk_OBJECTS = $(diffkk_dir)/diffkk.o $(diffkk_dir)/lib.o \
	$(diffkk_dir)/dkinp.o $(diffkk_dir)/str2at.o $(diffkk_dir)/dkfit.o \
	$(diffkk_dir)/dkfcn.o $(diffkk_dir)/dklog.o


feff6_OBJECTS = $(feff6_dir)/feff.o $(feff6_dir)/str.o \
	$(feff6_dir)/rdinp.o $(feff6_dir)/chopen.o \
	$(feff6_dir)/mkptz.o $(feff6_dir)/setgam.o \
	$(feff6_dir)/terp.o $(feff6_dir)/potph.o \
	$(feff6_dir)/rpotph.o $(feff6_dir)/rdhead.o \
	$(feff6_dir)/atom.o $(feff6_dir)/indata.o \
	$(feff6_dir)/getorb.o $(feff6_dir)/dirac.o \
	$(feff6_dir)/inouh.o $(feff6_dir)/inth.o \
	$(feff6_dir)/potsl.o $(feff6_dir)/somm.o \
	$(feff6_dir)/totale.o $(feff6_dir)/cdsld.o \
	$(feff6_dir)/ykdir.o $(feff6_dir)/renorm.o \
	$(feff6_dir)/potslw.o $(feff6_dir)/ovrlp.o \
	$(feff6_dir)/sumax.o $(feff6_dir)/frnrm.o \
	$(feff6_dir)/istprm.o $(feff6_dir)/sidx.o \
	$(feff6_dir)/istval.o $(feff6_dir)/fermi.o \
	$(feff6_dir)/head.o $(feff6_dir)/wpot.o \
	$(feff6_dir)/phmesh.o $(feff6_dir)/fixvar.o \
	$(feff6_dir)/phase.o $(feff6_dir)/besjn.o \
	$(feff6_dir)/bjnser.o $(feff6_dir)/xcpot.o \
	$(feff6_dir)/rhl.o $(feff6_dir)/imhl.o \
	$(feff6_dir)/ffq.o $(feff6_dir)/cubic.o \
	$(feff6_dir)/quinn.o $(feff6_dir)/edp.o \
	$(feff6_dir)/fovrg.o $(feff6_dir)/diff.o \
	$(feff6_dir)/intpol.o $(feff6_dir)/wphase.o \
	$(feff6_dir)/prcrit.o $(feff6_dir)/rphbin.o \
	$(feff6_dir)/cpl0.o $(feff6_dir)/paths.o \
	$(feff6_dir)/sortix.o $(feff6_dir)/ccrit.o \
	$(feff6_dir)/mrb.o $(feff6_dir)/mcrith.o \
	$(feff6_dir)/mcritk.o $(feff6_dir)/ipack.o \
	$(feff6_dir)/heap.o $(feff6_dir)/pathsd.o \
	$(feff6_dir)/timrep.o $(feff6_dir)/mpprmp.o \
	$(feff6_dir)/phash.o $(feff6_dir)/outcrt.o \
	$(feff6_dir)/strap.o $(feff6_dir)/mpprmd.o \
	$(feff6_dir)/genfmt.o $(feff6_dir)/snlm.o \
	$(feff6_dir)/rdpath.o $(feff6_dir)/setlam.o \
	$(feff6_dir)/rot3i.o $(feff6_dir)/mmtr.o \
	$(feff6_dir)/sclmz.o $(feff6_dir)/mmtrxi.o \
	$(feff6_dir)/fmtrxi.o $(feff6_dir)/trap.o \
	$(feff6_dir)/pijump.o $(feff6_dir)/ff2chi.o \
	$(feff6_dir)/sigms.o $(feff6_dir)/dist.o \
	$(feff6_dir)/sdist.o $(feff6_dir)/xx.o \
	$(feff6_dir)/getxk.o $(feff6_dir)/dalp.o \
	$(feff6_dir)/fpot.o $(feff6_dir)/exchan.o \
	$(feff6_dir)/exchee.o $(feff6_dir)/pertab.o 


EL_DATAFILES = 04.dat 05.dat 06.dat 07.dat 08.dat 09.dat 10.dat 11.dat \
	12.dat 13.dat 14.dat 15.dat 16.dat 17.dat 18.dat 19.dat 20.dat \
	21.dat 22.dat 23.dat 24.dat 25.dat 26.dat 27.dat 28.dat 29.dat \
	30.dat 31.dat 32.dat 33.dat 34.dat 35.dat 36.dat 37.dat 38.dat \
	39.dat 40.dat 41.dat 42.dat 43.dat 44.dat 45.dat 46.dat 47.dat \
	48.dat 49.dat 50.dat 51.dat 52.dat 53.dat 54.dat 55.dat 56.dat \
	57.dat 58.dat 59.dat 60.dat 61.dat 62.dat 63.dat 64.dat 65.dat \
	66.dat 67.dat 68.dat 69.dat 70.dat 71.dat 72.dat 73.dat 74.dat \
	75.dat 76.dat 77.dat 78.dat 79.dat 80.dat 81.dat 82.dat 83.dat \
	84.dat 85.dat 86.dat 87.dat 88.dat 89.dat 90.dat 91.dat 92.dat

$(HEADERS):
	$(SHELL) $(IFF_CONFIG)



Config.mak: $(OBJECTS)
	@echo '#==  Ifeffit build configuration:'     > $@
	@echo '#    LIB_IFF = ifeffit library  '     >> $@
	@echo '#    LIB_PLT = PGPLOT  libraries'     >> $@
	@echo '#    LIB_F77 = Fortran libraries'     >> $@
	@echo '#    LIB_X11 = X Libaries'            >> $@
	@echo '#    INC_IFF = location of ifeffit.h' >> $@
	@echo 'LIB_IFF  = -L$(prefix)/lib -lifeffit' >> $@
	@echo 'LIB_PLT  = $(PGPLOT_LIBS)'            >> $@
	@echo 'LIB_F77  = $(MN_FLIBS) '              >> $@
	@echo 'INC_IFF  = -I$(pkgdatadir)/config'    >> $@
	@echo '#==  ' >> $@
	@echo 'made $@'

## BR Mar 28 2002: I want to make a few comments on some cryptic crap
## I added to this target.  The combination of explicitly setting
## LDDLFLAGS and adding perl's $Config{ldflags} to the value of LIBS
## is intended to move /usr/local/lib to a position after
## ../../src/lib in the command line argument to the linker.  In this
## way the newly compiled libifeffit will be used in place of one that
## exists in the location of $Config{ldflags}.  By default LDDLFLAGS
## will be set to $Config{lddlflags} which is "-shared " concatinated
## with $Config{ldflags}.  The complicated join/sort/split thing is
## intended to offer a clumsy but servicable to solution to a mistake
## made by autoconf on many linux systems.  Doing the join/sort/split
## thing will assure that the -l***'s will be placed after the -L***'s
## on the command line and the -lm will be placed after either -lg2c
## or -lf2c.  Note that the join/sort/split could be fragile.
Makefile.PL: Config.mak
	@echo '#  -*-perl-*-' > $@
	@echo '#  Perl Makefile.PL auto-generated during Ifeffit build' >> $@
	@echo '#  This file may need some modifications, but should give' >> $@
	@echo '#  a good guess for how to build the Ifeffit extension.' >> $@
	@echo '#  ' >> $@
	@echo "use lib '.';" >> $@
	@echo "use ExtUtils::MakeMaker;" >> $@
	@echo "use Config;" >> $@
	@echo "WriteMakefile('NAME'   => 'Ifeffit'," >> $@
	@echo "              'SKIP'   => ['test_dynamic'],"  >> $@
	@echo "              'OBJECT' => 'ifeffit_wrap.o',"  >> $@
	@echo "              'INSTALLBIN'    => '$(bindir)',">> $@
	@echo "              'INSTALLSCRIPT' => '$(bindir)',">> $@
	@echo "              'LDDLFLAGS'     => '$(LDDLFLAGS_P5)',"  >> $@
	@echo "              'INC'    => '-I../../src/lib -I$(pkgdatadir)/config'," >> $@
	@echo "              'LIBS'   =>[' -L../../src/lib '.\$$Config{ldflags}." >> $@
	@echo "                    ' -lifeffit $(PGPLOT_LIBS) '." >> $@
	@echo "                    join(\" \", (sort(split(\" \", \"$(MN_FLIBS)\" ))))] " >> $@
	@echo "         );" >> $@
	@echo 'made $@'
	@cp $@ $(top_srcdir)/wrappers/perl/.

#
# python setup
site_install.py: Config.mak
	@echo '#  -*-python-*-' > $@
	@echo '#  Python site installation information'                   >> $@
	@echo '#  This file was auto-generated during the Ifeffit build'  >> $@
	@echo '#  and may need some modifications.'                       >> $@
	@echo '#  '                      >> $@
	@echo 'bin_dir="$(bindir)"' > $@
	@echo 'lib_iff="-L$(prefix)/lib -lifeffit "' >> $@
	@echo 'lib_plt="$(PGPLOT_LIBS)"'             >> $@ 
	@echo 'lib_f77="$(MN_FLIBS) "'               >> $@
	@echo 'inc_iff="-I../../src/lib -I$(pkgdatadir)/config"' >> $@
	@echo 'made $@'
	@cp $@ $(top_srcdir)/wrappers/python/.


TclSetup.in: Config.mak
	@echo '#  ' > $@
	@echo '#  Tcl Setup.in auto-generated during Ifeffit build' >> $@
	@echo '#  This file may need some modifications, but should give' >> $@
	@echo '#  a good guess for how to build the Ifeffit extension.' >> $@
	@echo '#  ' >> $@
	@cat Config.mak >> $@
	@echo 'LIB_IFF  = -L../../src/lib -lifeffit ' >> $@
	@echo 'INC_IFF  = -I../../src/lib -I$(pkgdatadir)/config' >> $@
	@echo 'CC       = $(CCLD)'     >> $@
	@echo 'CFLAGS   = $(CFLAGS)'   >> $@
	@echo 'LDFLAGS  = $(LDFLAGS)'  >> $@
	@echo 'made $@'
	@cp $@ $(top_srcdir)/wrappers/tcl/.



.f.o:
	$(F77) -o $@ -c $<


%.o: %.c
	$(COMPILE) -o $@ -c $<

libifeffit.a: $(lib_OBJECTS)
	-rm -f $@
	$(AR) cru libifeffit.a $(lib_OBJECTS)
	$(RANLIB) libifeffit.a

libxafs.a: $(XAFS_OBJ)
	-rm -f $@
	$(AR) cru libxafs.a $(XAFS_OBJ)
	$(RANLIB) libxafs.a


ifeffit: $(ifeffit_OBJECTS) libifeffit.a
	@rm -f $@
	$(LINK) $(ifeffit_OBJECTS) libifeffit.a \
	$(PGPLOT_LIBS) $(READLINE_LIBS) $(FLIBS)

autobk: $(autobk_OBJECTS) libxafs.a
	@rm -f $@
	$(F77LINK) $(autobk_OBJECTS) libxafs.a $(FLIBS)

feffit: $(feffit_OBJECTS) libxafs.a
	@rm -f $@
	$(F77LINK) $(feffit_OBJECTS) libxafs.a $(FLIBS)


diffkk: $(diffkk_OBJECTS) libifeffit.a
	@rm -f $@
	$(F77LINK) $(diffkk_OBJECTS) libifeffit.a \
	$(PGPLOT_LIBS) $(FLIBS)


feff6: $(feff6_OBJECTS)
	@rm -f $@
	$(F77LINK) $(feff6_OBJECTS) $(FLIBS)


install: all
# libs
	$(mkinstalldirs) $(libdir)
	$(SET_DIR_PERM) $(libdir)
	@list='$(LIBRARIES)'; for p in $$list; do \
	  if test -f $$p; then \
	    echo "$(INSTALL_DATA) $$p $(libdir)/$$p"; \
	    $(INSTALL_DATA) $$p $(libdir)/$$p; \
	    $(RANLIB) $(libdir)/$$p; \
	  else :; fi; \
	done
# binaries
	$(mkinstalldirs) $(bindir)
	$(SET_DIR_PERM)  $(bindir)
	@list='$(EXE)'; for p in $$list; do \
	  echo "$(INSTALL_EXE) $$p $(bindir)/$$p"; \
	  $(INSTALL_EXE) $$p $(bindir)/$$p; \
	done
# data files for base share data install
	$(mkinstalldirs) $(pkgdatadir)
	$(SET_DIR_PERM)  $(pkgdatadir)
	@list='$(pkgdata_DATA)'; for p in $$list; do \
	    echo "$(INSTALL_DATA) $(srcdir)/$$p $(pkgdatadir)/$$p"; \
	    $(INSTALL_DATA) $(srcdir)/$$p $(pkgdatadir)/$$p; \
	done
# config files
	$(mkinstalldirs) $(pkgdatadir)/config
	$(SET_DIR_PERM)  $(pkgdatadir)/config
	@list='$(pkgconfig_DATA)'; for p in $$list; do \
	    echo "$(INSTALL_DATA) $$p $(pkgdatadir)/config/$$p"; \
	    $(INSTALL_DATA) $$p $(pkgdatadir)/config/$$p; \
	done

# data files for CL and Feff Tables
	$(mkinstalldirs) $(pkgdatadir)/cldata
	$(mkinstalldirs) $(pkgdatadir)/fefftab
	$(SET_DIR_PERM)  $(pkgdatadir)/cldata
	$(SET_DIR_PERM)  $(pkgdatadir)/fefftab
	@echo "installing cldata and fefftab data"
	@list='$(EL_DATAFILES)'; for p in $$list; do \
	    $(INSTALL_DATA) ../cldata/$$p $(pkgdatadir)/cldata/$$p; \
	    $(INSTALL_DATA) ../fefftab/$$p $(pkgdatadir)/fefftab/$$p; \
	done

clean:
	-rm -f core $(LIBRARIES) $(EXE) $(CONFIG_TEMPLATES) 
	@list='$(all_src_dirs)'; for p in $$list; do \
	    echo "rm -f $$p/*.o " ; \
	    rm -f $$p/*.o ; \
	done
