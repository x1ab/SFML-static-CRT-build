::
:: Build with BusyBox-w32 & MSVC
::
@echo off

set SZ_PRJDIR=SFML-master

call %~dp0tooling\_setenv.cmd
::
:: We've now been CD'd into PRJ_DIR!
::
busybox make -f ../tooling/bbMakefile.msvc %*
