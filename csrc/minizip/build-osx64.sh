[ `uname` = Linux ] && { export X=x86_64-apple-darwin19-; export CC=clang; }
P=osx64 C="-arch x86_64 -fPIC" L="-arch x86_64 ../../bin/$P/libz.a -install_name @rpath/libminizip.dylib" \
	D=libminizip.dylib A=libminizip.a ./build.sh
