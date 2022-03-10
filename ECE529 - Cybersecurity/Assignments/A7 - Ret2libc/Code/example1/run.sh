#!/bin/bash
echo -n "Setting ulimit to unlimited... " && ulimit -c unlimited && echo "done."
echo -n "Stopping apport service... " && sudo service apport stop && echo "done."
echo -n "Turning off ASLR... " && sudo echo -n 0 | sudo tee /proc/sys/kernel/randomize_va_space && echo " done."
echo -n "Setting PAYLOAD to bash... " && export PAYLOAD="/bin/bash" && echo "done."
echo "Testing PAYLOAD location three times:"
./getenv PAYLOAD
./getenv PAYLOAD
./getenv PAYLOAD