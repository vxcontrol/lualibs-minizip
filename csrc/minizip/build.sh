[ "$CC" ] || CC=gcc
C="$C -DHAVE_AES"
mkdir -p ../../bin/$P
${X}${CC} -c -O2 $C aes/aescrypt.c aes/aeskey.c aes/aestab.c aes/aes_ni.c aes/fileenc.c aes/hmac.c aes/prng.c aes/pwd2key.c aes/sha1.c -I. -Iaes
${X}${CC} -c -O2 $C $W crypt.c ioapi.c ioapi_buf.c ioapi_mem.c unzip.c zip.c minishared.c miniunz.c minizip.c -I. -I../zlib
${X}${CC} *.o -shared -o ../../bin/$P/$D -L../../bin/$P $L
rm -f      ../../bin/$P/$A
${X}ar rcs ../../bin/$P/$A *.o
rm *.o
