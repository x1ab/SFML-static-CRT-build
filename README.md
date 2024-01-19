### ABOUT

This small, frugal, self-containing (apart from a working MSVC shell, of
course) build scaffolding creates "true" static SFML build for MSVC, as
opposed to the shipped prebuilt lib versions that still depend on the
MSVC (redistributable) runtime DLLs that may or may not be present on a
target Windows instance.

IOW, the official SFML/MSVC binaries have been compiled with `-MD` (and `-MDd`
for DEBUG), whereas this setup builds with `-MT` (and `-MTd`) by default.
(You can still build for the DLL version of the CRT with `build CRT=dll`.)

Alternatively (in fact: preferably), if you can use CMake, you should just
run (in the repo dir):

	cmake -D SFML_OS_WINDOWS=TRUE -D SFML_USE_STATIC_STD_LIBS=TRUE .

or, for DEBUG:

	cmake -D SFML_OS_WINDOWS=TRUE -D SFML_USE_STATIC_STD_LIBS=TRUE -D CMAKE_BUILD_TYPE=Debug .

then:

	nmake

and call it a day. (Note that the stock CMake build will not name the fully
static version differently, so you can't have both -MT and -MT libs at the
same time!)

This tool is for cases when CMake can't be used for some reason or another.

------------------------------------------------------------------------------

### BEWARE!

This is an experimental proof-of-concept prototype tool for my own personal
use, to quickly test integrating "SFML/MT" with some other projects.

The scripts and the makefile have been ripped out of some other existing
configurations, _where this build setup was already pretty experimental to 
begin with..._ :) (I've been test-driving the surprisingly usable built-in
make tool of [BusyBox-w32](https://github.com/rmyorston/busybox-w32/).)

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

### NOTE:

- It's not possible to mix differently compiled object code, so if you
want to ensure that your app (or even just a simple static lib) that uses
SFML doesn't "secretly" depend on any of the MSVC runtime DLLs, then
recompiling SFML from source is your only option.

- The generated static libs with the also static CRT dependency will have
an extra `-s` suffix (in addition to the official one), e.g.
`sfml-window-s-s.lib` or `sfml-window-s-s-d.lib`. (This scheme simply
follows the original logic of "-s for static, nothing for DLL"...)

- The external `OpenAL.dll` library will still be linked dynamically
(no way around that, AFAIK), but at least you can just easily ship that
along with your executable (unlike the MSVC Redist. package).

- Only building the 64-bit version is explicitly supported by this guide,
but it should be pretty straightforward to do the same for 32-bit, too.

------------------------------------------------------------------------------

### BUILD STEPS


#### 1. Download and unpack the SFML source repo

	https://github.com/SFML/SFML/archive/refs/heads/master.zip

  (Note that this is the latest pre-3.0 branch, very much in flux, but
  still very usable and robust, albeit breaking the API occasionally.)

  The unpacked repo (should be `SFML-master` -- adjust the build script
  if it isn't) is expeted to be in the same dir as the `build` script.


#### 2. One small "fix"...

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

  With no options, it will build a non-debug ("release") version (with -O2 and
  `NDEBUG`), against the static MSVC runtime libs (`-MT`).

  Optionally, you can specify `CRT=dll` to build the original ("half") static
  SFML libs, or `DEBUG=1` for a debug version, e.g.:

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


#### 5. Create release package [OPTIONAL]

Using the `tooling/package.template` package skeleton:

Copy the new libs, and -- depending on how standalone and complete you want
to make the package -- optionally also `include`, stuff from `extlibs` (i.e.
`libs-msvc-universal` and `OpenAL.dll` from `extlibs/bin/...` to `bin`) etc.

Create an empty file with the name `VERSION/<SFML-master commit hash>`.

Zip it all up with the name `SFML-master-vc17-64-staticCRT.zip`, and if the
debug lib versions go in their own separate sub-addon package, preferably call
that one `SFML-master-vc17-64-staticCRT-d.zip`.

Finally create a new release at https://github.com/x1ab/SFML-staticCRT-build,
and upload the new zip files as assets.

NOTE: The packages are linked to at https://github.com/x1ab/x1ab.github.io,
hence the strict naming. The current URL of the "canonical" download page:

  https://x1ab.github.io/download/SFML/3.0-pre/custom/


#### 6. There's no `build clean`

Just delete the `.build.tmp` dir (or only its build-mode specific subtree
that you want to fully rebuild).
