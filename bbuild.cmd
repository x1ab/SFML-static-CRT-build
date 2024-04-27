::
:: Build with BusyBox-w32 & MSVC
::
@echo off

::!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
:: See cbuild.cmd for building with CMake!
:: Also, for downloading the latest master (without building): `cbuild dl`
::!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

set "SZ_PRJDIR=SFML-master"
set "SZ_SFML_DL_URL=https://github.com/SFML/SFML/archive/refs/heads/master.zip"
set "SZ_SFML_PACK_FILENAME=master.zip"

call %~dp0tooling\_setenv.cmd
::
:: We've now been CD'd into the repo dir.
::

busybox make -f ../tooling/bbMakefile.msvc %1 %2 %3 %4 %5
