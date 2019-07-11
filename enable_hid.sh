#!/bin/bash

modprobe libcomposite
cd /sys/kernel/config/usb_gadget/
mkdir -p SleepyGadget
cd SleepyGadget

echo 0x1d6b > idVendor # 0x1d6b = Linux Foundation 0x45e = Microsoft
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2

echo 0xEF > bDeviceClass
echo 0x02 > bDeviceSubClass
echo 0x01 > bDeviceProtocol

mkdir -p strings/0x409
echo "5eaf00d0b57ac1e" > strings/0x409/serialnumber
echo "BaristaLabs, LLC" > strings/0x409/manufacturer
echo "SleepyGadget" > strings/0x409/product

mkdir -p configs/c.1
echo 250 > configs/c.1/MaxPower

# Add functions here

#keyboard
mkdir -p functions/hid.usb0
echo 1 > functions/hid.usb0/protocol
echo 1 > functions/hid.usb0/subclass
echo 8 > functions/hid.usb0/report_length
echo -ne \\x05\\x01\\x09\\x06\\xa1\\x01\\x05\\x07\\x19\\xe0\\x29\\xe7\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\x95\\x01\\x75\\x08\\x81\\x03\\x95\\x05\\x75\\x01\\x05\\x08\\x19\\x01\\x29\\x05\\x91\\x02\\x95\\x01\\x75\\x03\\x91\\x03\\x95\\x06\\x75\\x08\\x15\\x00\\x25\\x65\\x05\\x07\\x19\\x00\\x29\\x65\\x81\\x00\\xc0 > functions/hid.usb0/report_desc
ln -s functions/hid.usb0 configs/c.1/

# mouse
mkdir -p functions/hid.usb1
echo 2 > functions/hid.usb1/protocol
echo 1 > functions/hid.usb1/subclass
echo 4 > functions/hid.usb1/report_length
echo -ne \\x05\\x01\\x09\\x02\\xa1\\x01\\x09\\x01\\xa1\\x00\\x05\\x09\\x19\\x01\\x29\\x05\\x15\\x00\\x25\\x01\\x95\\x05\\x75\\x01\\x81\\x02\\x95\\x01\\x75\\x03\\x81\\x01\\x05\\x01\\x09\\x30\\x09\\x31\\x09\\x38\\x15\\x81\\x25\\x7f\\x75\\x08\\x95\\x03\\x81\\x06\\xc0\\xc0 > functions/hid.usb1/report_desc
ln -s functions/hid.usb1 configs/c.1/

# joystick - Simple 2 axis, 2 button.
mkdir -p functions/hid.usb2
echo 0 > functions/hid.usb2/protocol
echo 0 > functions/hid.usb2/subclass
echo 8 > functions/hid.usb2/report_length
# Descriptor from https://github.com/NordicSemiconductor/ble-sdk-arduino/blob/master/libraries/BLE/examples/ble_HID_template/USD%20HID%20Report%20Descriptor%20-%20Joystick.txt
echo -ne \\x05\\x01\\x09\\x04\\xa1\\x01\\x85\\x01\\xa1\\x02\\x09\\x32\\x09\\x31\\x09\\x30\\x15\\x00\\x26\\xff\\x00\\x35\\x00\\x46\\xff\\x00\\x75\\x08\\x95\\x03\\x81\\x02\\xc0\\x85\\x02\\xa1\\x02\\x05\\x09\\x29\\x02\\x19\\x01\\x95\\x02\\x75\\x01\\x25\\x01\\x15\\x00\\x81\\x02\\x95\\x01\\x75\\x06\\x81\\x01\\xc0\\xc0 > functions/hid.usb2/report_desc
ln -s functions/hid.usb2 configs/c.1/

# End functions

# OS descriptors
echo 1       > os_desc/use
echo 0xcd    > os_desc/b_vendor_code
echo MSFT100 > os_desc/qw_sign

ln -s configs/c.1 os_desc

udevadm settle -t 5 || :
ls /sys/class/udc > UDC

dhclient -v -r wlan0
dhclient -v wlan0