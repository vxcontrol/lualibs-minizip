[ `uname` = Linux ] && { export X=i686-w64-mingw32-; }
P=mingw32 W="iowin32.c" C="-fPIC" L="-s -static-libgcc ../../bin/$P/z.a" \
    D=minizip.dll A=minizip.a ./build.sh
