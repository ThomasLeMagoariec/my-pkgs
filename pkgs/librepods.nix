{
    stdenv,
    lib,
    fetchFromGitHub,
    makeDesktopItem,
    cmake,
	pkg-config,
	libpulseaudio,
    qt6,
}:
let
desktopItem = makeDesktopItem {
    name = "librepods";
    desktopName = "librepods";
    exec = "librepods";
    categories = [ "Utility" ];
};

in
stdenv.mkDerivation {
    pname = "librepods";
    version = "v0.1.0-rc.4";

    src = fetchFromGitHub {
        owner = "librepods-org";
        repo = "librepods";
        rev = "v1.0.0-rc1";
        sha256 = "0hii63csiqaqpx2ydb1i4c25jvbgihg6w4q7fan0qbmhfzrmflj3";

    };

    sourceRoot = "source/linux";

    buildInputs = [
        cmake
		pkg-config
		libpulseaudio
        qt6.wrapQtAppsHook
        qt6.qtbase 
        qt6.qtdeclarative 
        qt6.qtconnectivity
		qt6.qttools
    ];

    installPhase = ''
        runHook preinstall

        mkdir build
        cd build
        cmake ..
        cd ..
        make

        mkdir -p $out/bin
        install -Dm755 librepods $out/bin/librepods

        mkdir -p $out/share/applications
        cp ${desktopItem}/share/applications/*.desktop \
              $out/share/applications/

        runHook postInstall
    '';
}
