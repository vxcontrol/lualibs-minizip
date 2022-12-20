[ `uname` = Linux ] && { export X=x86_64-w64-mingw32-; }
P=mingw64 W="iowin32.c" C="-fPIC" L="-s -static-libgcc ../../bin/$P/z.a" \
    D=minizip.dll A=minizip.a ./build.sh
