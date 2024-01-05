@echo off 
rem

call emsdk_env.bat
rmdir /s /q dist
rmdir /s /q build
mkdir build
mkdir dist
cd build

SET EMSCRIPTEN_ROOT=%EMSDK%/upstream/emscripten

%EMSDK_PYTHON% %EMSCRIPTEN_ROOT%/tools/webidl_binder.py ../wasm/Box2D.idl box2d_glue

call emcmake cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS= ../box2d -DBOX2D_BUILD_UNIT_TESTS=OFF -DBOX2D_BUILD_DOCS=OFF -DBOX2D_BUILD_TESTBED=OFF
echo Compiling C++ to LLVM IR
call emmake make

echo Building wasm
call emcc ../wasm/glue_stub.cpp bin/libbox2d.a  -I ../box2d/include -fno-rtti -fno-exceptions -s MODULARIZE=1 -s EXPORT_NAME=Box2D -s ALLOW_TABLE_GROWTH=1 --memory-init-file 0 -s FILESYSTEM=0 -s SUPPORT_LONGJMP=0 -s EXPORTED_FUNCTIONS=_malloc,_free -s ALLOW_MEMORY_GROWTH=1 -g3 -s ASSERTIONS=2 -s DEMANGLE_SUPPORT=1  --oformat=bare -o Box2D.bare.wasm
call emcc --post-link Box2D.bare.wasm --post-js box2d_glue.js -fno-rtti -fno-exceptions -s MODULARIZE=1 -s EXPORT_NAME=Box2D -s ALLOW_TABLE_GROWTH=1 --memory-init-file 0 -s FILESYSTEM=0 -s SUPPORT_LONGJMP=0 -s EXPORTED_FUNCTIONS=_malloc,_free -s ALLOW_MEMORY_GROWTH=1 -g3 -s ASSERTIONS=2 -s DEMANGLE_SUPPORT=1 -o ../dist/laya.Box2D.wasm.js

echo Building js
call emcc ../wasm/glue_stub.cpp bin/libbox2d.a  -I ../box2d/include -fno-rtti -fno-exceptions -s MODULARIZE=1 -s EXPORT_NAME=Box2D -s ALLOW_TABLE_GROWTH=1 --memory-init-file 0 -s FILESYSTEM=0 -s SUPPORT_LONGJMP=0 -s EXPORTED_FUNCTIONS=_malloc,_free -s ALLOW_MEMORY_GROWTH=1 -g3 -s ASSERTIONS=2 -s DEMANGLE_SUPPORT=1 -s WASM=0 --oformat=bare -o Box2D.bare.wasm
call emcc --post-link Box2D.bare.wasm --post-js box2d_glue.js -fno-rtti -fno-exceptions -s MODULARIZE=1 -s EXPORT_NAME=Box2D -s ALLOW_TABLE_GROWTH=1 --memory-init-file 0 -s FILESYSTEM=0 -s SUPPORT_LONGJMP=0 -s EXPORTED_FUNCTIONS=_malloc,_free -s ALLOW_MEMORY_GROWTH=1 -g3 -s ASSERTIONS=2 -s DEMANGLE_SUPPORT=1 -s WASM=0 -o ../dist/laya.Box2D.js
cd ..
