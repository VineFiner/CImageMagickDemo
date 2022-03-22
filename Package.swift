// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CImageMagickDemo",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/VineFiner/CImageMagick.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "CImageMagickDemo",
            dependencies: [
                "CImageMagick"
            ]
            /**
             ➜  CImageMagickDemo pkg-config --cflags-only-other ImageMagick
             -Xpreprocessor -fopenmp -DMAGICKCORE_HDRI_ENABLE=1 -DMAGICKCORE_QUANTUM_DEPTH=16
             */
            ,cxxSettings: [
                .define("MAGICKCORE_HDRI_ENABLE", to: "1"),
                .define("MAGICKCORE_QUANTUM_DEPTH", to: "16"),
            ]
            /**
             ➜  CImageMagickDemo pkg-config --cflags-only-I MagickWand
             -I/usr/local/Cellar/imagemagick/7.1.0-8/include/ImageMagick-7
             */
            ,swiftSettings: [
                .unsafeFlags(["-I/usr/local/Cellar/imagemagick/7.1.0-8/include/ImageMagick-7"],
                             .when(platforms: [.macOS], configuration: .debug)),
                .unsafeFlags(["-I/usr/local/include/ImageMagick-7"],
                             .when(platforms: [.linux], configuration: .debug)),
            ]
            /**
             ➜  CImageMagickDemo pkg-config --libs MagickWand
             -L/usr/local/Cellar/imagemagick/7.1.0-8/lib -lMagickWand-7.Q16HDRI -lMagickCore-7.Q16HDRI
             */
            ,linkerSettings: [
                .unsafeFlags([
                    "-L/usr/local/Cellar/imagemagick/7.1.0-8/lib",
                    "-lMagickWand-7.Q16HDRI",
                    "-lMagickCore-7.Q16HDRI"
                ], .when(platforms: [.macOS], configuration: .debug)),
                .unsafeFlags([
                    "-L/usr/local/lib",
                    "-lMagickWand-7.Q16HDRI",
                    "-lMagickCore-7.Q16HDRI"
                ], .when(platforms: [.linux], configuration: .debug))
            ]
            /*
             swift run \
             -Xcc -DMAGICKCORE_HDRI_ENABLE=1 \
             -Xcc -DMAGICKCORE_QUANTUM_DEPTH=16 \
             -Xswiftc -I/usr/local/Cellar/imagemagick/7.0.10-0/include/ImageMagick-7 \
             -Xlinker -L/usr/local/Cellar/imagemagick/7.0.10-0/lib \
             -Xlinker -lMagickWand-7.Q16HDRI \
             -Xlinker -lMagickCore-7.Q16HDRI
             */
        ),
        .testTarget(
            name: "CImageMagickDemoTests",
            dependencies: ["CImageMagickDemo"]),
    ]
)
