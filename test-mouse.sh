#!/bin/bash

# Test if is Root
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo -ne "\x02\x00\x00\x00" > /dev/hidg1
echo -ne "\x00\x00\x00\x00" > /dev/hidg1