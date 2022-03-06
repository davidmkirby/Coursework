CC=gcc
OBJ=function-args.o #function2.o print.o err.o
CC_FLAGS=-g -fno-stack-protector -z execstack

%.o: %.c
	$(CC) -c -o $@ $< $(CC_FLAGS)

main: $(OBJ)
#	$(CC) -o f2 function2.o $(CC_FLAGS)
	$(CC) -o fa function-args.o $(CC_FLAGS)
#	$(CC) -o print print.o $(CC_FLAGS)
#	$(CC) -o err err.o $(CC_FLAGS)

clean:
	rm *.o f2 print err
	rm -rf a.out
