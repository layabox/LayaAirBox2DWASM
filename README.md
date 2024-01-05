
Get the Box2D source code, run the following:

    1:git submodule init
    2:git submodule update
    3:cd box2d
    4:git checkout -b branches/tags v2.4.1
    5:cd ..


Building
--------

In order to build box2d.js yourself, you will need
[Emscripten](http://emscripten.org) and [cmake](https://cmake.org/download).

For more information about setting up Emscripten, see the [getting started
guide](https://emscripten.org/docs/getting_started).

To configure and build box2d into the `build` directory, run the following:
    build.bat