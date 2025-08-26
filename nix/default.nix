{
  rev,
  lib,
  stdenv,
  makeWrapper,
  makeFontsConf,
  fish,
  ddcutil,
  brightnessctl,
  app2unit,
  cava,
  networkmanager,
  lm_sensors,
  grim,
  swappy,
  wl-clipboard,
  libqalculate,
  inotify-tools,
  bluez,
  bash,
  hyprland,
  coreutils,
  findutils,
  file,
  material-symbols,
  rubik,
  nerd-fonts,
  gcc,
  qt6,
  quickshell,
  aubio,
  pipewire,
  caelestia-cli,
  withCli ? false,
  extraRuntimeDeps ? [],
}: let
  runtimeDeps =
    [
      fish
      ddcutil
      brightnessctl
      app2unit
      cava
      networkmanager
      lm_sensors
      grim
      swappy
      wl-clipboard
      libqalculate
      inotify-tools
      bluez
      bash
      hyprland
      coreutils
      findutils
      file
    ]
    ++ extraRuntimeDeps
    ++ lib.optional withCli caelestia-cli;

  fontconfig = makeFontsConf {
    fontDirectories = [material-symbols rubik nerd-fonts.caskaydia-cove];
  };
in
  stdenv.mkDerivation {
    pname = "caelestia-shell";
    version = "${rev}";
    src = ./..;

    nativeBuildInputs = [gcc makeWrapper qt6.wrapQtAppsHook];
    buildInputs = [quickshell aubio pipewire qt6.qtbase];
    propagatedBuildInputs = runtimeDeps;

    buildPhase = ''
      mkdir -p bin
      g++ -std=c++17 -Wall -Wextra \
      	-I${pipewire.dev}/include/pipewire-0.3 \
      	-I${pipewire.dev}/include/spa-0.2 \
      	-I${aubio}/include/aubio \
      	assets/beat_detector.cpp \
      	-o bin/beat_detector \
      	-lpipewire-0.3 -laubio
    '';

    installPhase = ''
      install -Dm755 bin/beat_detector $out/bin/beat_detector

      mkdir -p $out/share/caelestia-shell
      cp -r ./* $out/share/caelestia-shell

      makeWrapper ${quickshell}/bin/qs $out/bin/caelestia-shell \
      	--prefix PATH : "${lib.makeBinPath runtimeDeps}" \
      	--set FONTCONFIG_FILE "${fontconfig}" \
      	--set CAELESTIA_BD_PATH $out/bin/beat_detector \
      	--add-flags "-p $out/share/caelestia-shell"
    '';

    meta = {
      description = "A very segsy desktop shell";
      homepage = "https://github.com/caelestia-dots/shell";
      license = lib.licenses.gpl3Only;
      mainProgram = "caelestia-shell";
    };
  }
