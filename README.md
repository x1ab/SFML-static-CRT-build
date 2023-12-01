﻿### ABOUT

This small, frugal, self-containing (apart from a working MSVC shell, of
course) build scaffolding creates "true" static builds of SFML for MSVC,
as opposed to the shipped prebuilt lib versions that still depend on the
MSVC (redistributable) runtime library DLLs, that may or may not be present
on a target Windows instance.

IOW, the official SFML binaries have been compiled with `-MD` (and `-MDd`
for DEBUG), whereas this setup builds with `-MT` (and `-MTd`) by default.
(You can still build for the DLL version of the CRT with `build CRT=dll`.)

Note that it's not possible to mix differently compiled object code, so
if you want to ensure that your app (or even just a simple static lib) that
uses SFML doesn't "secretly" depend on any of the MSVC runtime DLLs, then
recompiling SFML from source is your only option.

The generated static libs with the also static CRT dependency will have
an extra `-s` suffix (in addition to the official one), e.g.
`sfml-window-s-s.lib` or `sfml-window-s-s-d.lib`. (This scheme follows the
original implicit general logic of "-s for static, nothing for DLL"...)

NOTE: The external `OpenAL.dll` library will still be linked dynamically
(no way around that, AFAIK), but at least you can just easily ship that
along with your executable (unlike the MSVC Redist. package).

------------------------------------------------------------------------------

### BEWARE!

This is an experimental proof-of-concept prototype tool for my own personal
use, to quickly test integrating "SFML/MT" with some other projects.

The scripts and the makefile have been ripped out of some other existing
configurations, _where this build setup was already pretty experimental to 
begin with!_ :) (I've been test-driving the surprisingly usable built-in make
tool of [BusyBox-w32](https://github.com/rmyorston/busybox-w32/).)

So, this stuff here is full of weird remnants and junk -- OTOH, it still
worked so well (thanks to the beautifully clean SFML repo, and its general
build-friendly qualities, with all the external dependencies prepackaged*
etc.) that I've just proceeded to baseline it as "the" build tool for this
particular purpose of mine, in the context of my own projects.

Your mileage may vary.

\* <sub>FTR: I actually forgot that SFML comes with batteries included, and I
   initially downloaded & compiled everything from scratch, individually,
   fixing issues here and there etc., only to realize after-the-fact that
   I worked so hard for absolutely nothing... (I have a mild case of ADD,
   and didn't even realize that the repo already has an `extlibs` dir! :) )</sub>

------------------------------------------------------------------------------

### BUILD STEPS

#### 1. Download and unpack the SFML source repo

	https://github.com/SFML/SFML/archive/refs/heads/master.zip

  (Note that this is the latest pre-3.0 branch, very much in flux, but
  still very usable and robust, albeit breaking the API occasionally.)

  The unpacked repo (should be `SFML-master` -- adjust the build script
  if it isn't) is expeted to be in the same dir as the `build` script.

#### 2. One small fix...

  There's one thing I had to fix there: disable FLAC's assert.h in
  `extlibs\headers\FLAC`. It kept failing with `assert` being an undefined
  identifier, probably due to the `INCLUDE` path (ordering) set up by the
  scripts, and I couldn't quickly find the reason; but strangely enough,
  just taking that header down fixed it... :-o

#### 3. CRUCIAL: Remove the unused platform sources!

  This experimental makefile can't skip directories, and would just want
  to compile all the C/C++ files it can find in the source tree. So,
  
  ALL THE IRRELEVANT PLATFORM-SPECIFIC SOURCES MUST BE MOVED OUT
  OF THE WAY MANUALLY!
  

  Fortunately, this is very easy, too: just remove all but the `Win32` subdirs
  under `src`, namely from:

	- Window
	- Main
	- Network
	- System

  (or wherever else you may find any).

#### 4. Run `build`

  You can specify `CRT=dll` to build the original ("half") static libs, and 
  `DEBUG=1` for a debug version. E.g.:

	build

  would build the fully static libs in release mode (-DNDEBUG -O2), while

	build CRT=dll DEBUG=1

  would build for the DLL version of th MSVC runtime, with debug info and
  disabled optimizations.

  The generated .lib files are in the `lib` dir, created inside the repo, so
  that now it has a compatible layout with the official pre-built packages.
  (Except the `bin` dir, as this build tool does not build DLLs. It probably
  could, but I just didn't bother adding that without a good reason.)

  Note: each of the four supported build combinations are built in separate
  parallel "VPATH" trees, so you can incrementally rebuild them, if you wish,
  without interference.

#### 5.  There's no `build clean`

Just delete the `.build.tmp` dir (or only its build-mode specific subtree
that you want to fully rebuild).
