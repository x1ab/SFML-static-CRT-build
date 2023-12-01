@echo off
rem This is expected to be called from a (temporary) process context, where
rem the env. vars won't persist, and won't clash with anything important!

set SZ_APP_NAME=SFML-MT

rem !! These could crash horrendously, if e.g. a pre-existing value has & in it, etc...
rem !! Try with set "...=..."!

if "%SZ_PRJDIR%"=="" set SZ_PRJDIR=%~dp0..

set SZ_SRC_SUBDIR=src
set SZ_OUT_SUBDIR=.build.out
set SZ_LIB_SUBDIR=lib
set SZ_IFC_SUBDIR=ifc
set SZ_TEST_SUBDIR=test
set SZ_RUN_SUBDIR=%SZ_TEST_SUBDIR%
set SZ_ASSET_SUBDIR=asset
set SZ_RELEASE_SUBDIR=release

set SZ_SRC_DIR=%SZ_PRJDIR%/%SZ_SRC_SUBDIR%
set SZ_OUT_DIR=%SZ_PRJDIR%/%SZ_OUT_SUBDIR%
set SZ_LIB_DIR=%SZ_PRJDIR%/%SZ_LIB_SUBDIR%
set SZ_TEST_DIR=%SZ_PRJDIR%/%SZ_TEST_SUBDIR%
set SZ_RUN_DIR=%SZ_TEST_DIR%
set SZ_ASSET_DIR=%SZ_PRJDIR%/%SZ_ASSET_SUBDIR%
set SZ_TMP_DIR=%SZ_PRJDIR%/tmp
set SZ_RELEASE_DIR=%SZ_TMP_DIR%/%SZ_RELEASE_SUBDIR%

rem CD to prj root for the rest of the process:
cd "%SZ_PRJDIR%"
if errorlevel 1 (
	echo - ERROR: Failed to enter the project dir ^(%SZ_PRJDIR%^)^!
	exit 1
) else (
	rem Normalize the prj. dir ^(well, stil backslashes, awkwardly differing from the rest...^)
	set SZ_PRJDIR=%CD%
)

rem if not exist "%SZ_OUT_DIR%" md "%SZ_OUT_DIR%"


:: Extern...
set ext_inc=extlibs/headers
set ext_inc=%ext_inc%;extlibs/headers/glad/include;extlibs/headers/stb_image;extlibs/headers/freetype2;extlibs/headers/vulkan
set ext_inc=%ext_inc%;extlibs/headers/AL;extlibs/headers/ogg;extlibs/headers/FLAC;extlibs/headers/minimp3

set PATH=%SZ_PRJDIR%/../tooling;%SZ_SFML_LIBROOT%/bin;%PATH%
set LIB=%SZ_SFML_LIBROOT%/lib;%LIB%
set INCLUDE=%ext_inc%;%SZ_PRJDIR%/include;%SZ_PRJDIR%;%INCLUDE%
