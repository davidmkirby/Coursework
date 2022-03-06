ASM=exit.asm
OBJ=function2.o
CC_FLAGS=-g

%.o: %.c
	$(CC) -c -o $@ $< $(CC_FLAGS)

main: $(OBJ)
	$(CC) -o f2 function2.o $(CC_FLAGS)

clean:
	rm *.o f2
	rm -rf a.out
