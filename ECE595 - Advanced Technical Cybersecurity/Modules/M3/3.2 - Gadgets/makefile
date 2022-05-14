CC=gcc
OBJ=rop.o
CC_FLAGS= -no-pie -m32 -g -z execstack -fno-stack-protector

%.o: %.c
    $(CC) -c -o $@ $< $(CC_FLAGS)

main: $(OBJ)
    $(CC) -m32 -shared -o libgadgets.so -fPIC gadgets.c
	$(CC) -o rop rop.o $(CC_FLAGS)

clean:
	rm *.o rop *.so
	rm -rf a.out core