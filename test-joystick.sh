#!/bin/bash

# Test if is Root
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo -ne "\x7f\x7f\x7f\x14" > /dev/hidg2
sleep 1
echo -ne "\x00\x00\x00\x04" > /dev/hidg2