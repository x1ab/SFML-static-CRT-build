::
:: Build with CMake, and/or download the latest master sources
::
@echo off

:: Comment this out for a RELEASE build (setting to 0 is not enough!)
rem set DEBUG=1

set "SZ_PRJDIR=SFML-master"
set "SZ_SFML_DL_URL=https://github.com/SFML/SFML/archive/refs/heads/master.zip"
set "SZ_SFML_PACK_FILENAME=master.zip"
set "local_dl_dir=.."

if "%1"=="dl" goto :dl
echo Note: Use `%~n0 dl` to download the latest source pack first.

if exist "%SZ_PRJDIR%" goto :build
echo Note: "%SZ_PRJDIR%" not found, downloading new sources...

:dl
	shift
	pushd "%local_dl_dir%"
	if exist "%SZ_SFML_PACK_FILENAME%" del "%SZ_SFML_PACK_FILENAME%"
	busybox wget "%SZ_SFML_DL_URL%"
	if not errorlevel 1 echo OK. Unpack "%local_dl_dir%\%SZ_SFML_PACK_FILENAME%" manually to "%SZ_PRJDIR%", then rerun this script!
	popd
	goto :eof

:build
call %~dp0tooling\_setenv.cmd
::
:: We've now been CD'd into the repo dir.
::

:: Config...
::
:: NOTE: Changing the debug mode (i.e. DEBUG) might need manually cleaning any
::       leftover output artifacts from a previous (different) build.
::       (IOW: I'm just not sure how reliable --fresh below is in this use case.)
::
if not defined DEBUG (
	cmake --fresh -G "NMake Makefiles" -D SFML_OS_WINDOWS=TRUE -D SFML_USE_STATIC_STD_LIBS=TRUE "%SZ_PRJDIR%"
) else (
	cmake --fresh -G "NMake Makefiles" -D SFML_OS_WINDOWS=TRUE -D SFML_USE_STATIC_STD_LIBS=TRUE -D CMAKE_BUILD_TYPE=Debug "%SZ_PRJDIR%"
)

:: Build...
nmake
