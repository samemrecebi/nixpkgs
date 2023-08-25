{ lib
, stdenv
, fetchFromGitHub
, cmake
, glew
, freeimage
, liblockfile
, openal
, libtheora
, SDL2
, lzo
, libjpeg
, libogg
, pcre
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openxray";
  version = "2088-august-2023-rc1";

  src = fetchFromGitHub {
    owner = "OpenXRay";
    repo = "xray-16";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-f9EheVp05BAjjk3FIJjHVfm0piYiMYZJ9U156g2vhac=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    glew
    freeimage
    liblockfile
    openal
    libtheora
    SDL2
    lzo
    libjpeg
    libogg
    pcre
  ];

  # Crashes can happen, we'd like them to be reasonably debuggable
  cmakeBuildType = "RelWithDebInfo";
  dontStrip = true;

  makeWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
    # Needed because of dlopen module loading code
    "--prefix LD_LIBRARY_PATH : $out/lib"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Because we work around https://github.com/OpenXRay/xray-16/issues/1224 by using GCC,
    # we need a followup workaround for Darwin locale stuff when using GCC:
    # runtime error: locale::facet::_S_create_c_locale name not valid
    "--run 'export LC_ALL=C'"
  ];

  postInstall = ''
    wrapProgram $out/bin/xr_3da ${toString finalAttrs.makeWrapperArgs}
  '';

  meta = with lib; {
    mainProgram = "xr_3da";
    description = "Improved version of the X-Ray Engine, the game engine used in the world-famous S.T.A.L.K.E.R. game series by GSC Game World";
    homepage = "https://github.com/OpenXRay/xray-16/";
    license = licenses.unfree // {
      url = "https://github.com/OpenXRay/xray-16/blob/${version}/License.txt";
    };
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
})
