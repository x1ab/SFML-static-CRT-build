::!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
:: With CMake:
::
:: cmake -G "NMake Makefiles" -D SFML_OS_WINDOWS=TRUE -D SFML_USE_STATIC_STD_LIBS=TRUE SFML-master
:: Or, for DEBUG:
:: cmake -G "NMake Makefiles" -D SFML_OS_WINDOWS=TRUE -D SFML_USE_STATIC_STD_LIBS=TRUE -D CMAKE_BUILD_TYPE=Debug SFML-master
::
:: nmake
::!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

::
:: Build with BusyBox-w32 & MSVC
::
@echo off

set "SZ_PRJDIR=SFML-master"
set "SZ_SFML_DL_URL=https://github.com/SFML/SFML/archive/refs/heads/master.zip"
set "SZ_SFML_PACK_FILENAME=master.zip"

call %~dp0tooling\_setenv.cmd
::
:: We've now been CD'd into the repo dir.
::

if not "%1"=="dl" echo Use `%~n0 dl` to download the latest source pack first.
if     "%1"=="dl" (
	shift
	pushd ..
	if exist "%SZ_SFML_PACK_FILENAME%" del "%SZ_SFML_PACK_FILENAME%"
	busybox wget "%SZ_SFML_DL_URL%"
	popd
)

busybox make -f ../tooling/bbMakefile.msvc %1 %2 %3 %4 %5
