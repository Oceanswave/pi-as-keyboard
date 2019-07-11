#!/bin/bash

# Test if is Root
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo -ne "\x2\0\0\0" > /dev/hidg1
echo -ne "\0\0\0\0" > /dev/hidg1