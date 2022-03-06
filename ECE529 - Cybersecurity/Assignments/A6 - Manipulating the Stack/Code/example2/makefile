CC=gcc
OBJ=smash.o #function-args.o #function2.o print.o err.o
CC_FLAGS=-no-pie -m32 -g -z execstack -fno-stack-protector

%.o: %.c
	$(CC) -c -o $@ $< $(CC_FLAGS)

main: $(OBJ)
#	$(CC) -o getenv getenv.o $(CC_FLAGS)
	$(CC) -o smash smash.o $(CC_FLAGS) $(ALT_CC_FLAGS)
#	$(CC) -o f2 function2.o $(CC_FLAGS)
#	$(CC) -o fa function-args.o $(CC_FLAGS)
#	$(CC) -o print print.o $(CC_FLAGS)
#	$(CC) -o err err.o $(CC_FLAGS)
#	$(CC) -o err2 err2.o $(CC_FLAGS)

clean:
	rm *.o f2 print err err2 fa smash getenv
	rm -rf a.out core
