#!/bin/bash

# Test if is Root
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo -ne "\x12\x34\x56\x78\0\0\0\0\0\0\0\0\0\0\0" > /dev/hidg2
sleep 1
echo -ne "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0" > /dev/hidg2