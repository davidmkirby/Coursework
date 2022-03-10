CC=gcc
OBJ=getenv.o flawed-program.o
CC_FLAGS=-no-pie -m32 -g -z execstack -fno-stack-protector

%.o: %.c
	$(CC) -c -o $@ $< $(CC_FLAGS)

main: $(OBJ)
	$(CC) -o flawed-program flawed-program.o $(CC_FLAGS) $(ALT_CC_FLAGS)
	$(CC) -o getenv getenv.o $(CC_FLAGS)

clean:
	rm *.o flawed-program getenv
	rm -rf a.out core
