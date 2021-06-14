# usbreset
A program to issue from the command line a reset signal to a usb device

## source

```C
/* usbreset -- send a USB port reset to a USB device */

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/ioctl.h>

#include <linux/usbdevice_fs.h>


int main(int argc, char **argv)
{
    const char *filename;
    int fd;
    int rc;

    if (argc != 2) {
        fprintf(stderr, "Usage: usbreset device-filename\n");
        return 1;
    }
    filename = argv[1];

    fd = open(filename, O_WRONLY);
    if (fd < 0) {
        perror("Error opening output file");
        return 1;
    }

    printf("Resetting USB device %s\n", filename);
    rc = ioctl(fd, USBDEVFS_RESET, 0);
    if (rc < 0) {
        perror("Error in ioctl");
        return 1;
    }
    printf("Reset successful\n");

    close(fd);
    return 0;
}
```

Original location:
https://askubuntu.com/questions/645/how-do-you-reset-a-usb-device-from-the-command-line

## use

Run the following commands in terminal:

Compile the program:

$ cc usbreset.c -o usbreset
Get the Bus and Device ID of the USB device you want to reset:

$ lsusb  
Bus 002 Device 003: ID 0fe9:9010 DVICO  
Make our compiled program executable:

$ chmod +x usbreset
Execute the program with sudo privilege; make necessary substitution for <Bus> and <Device> ids as found by running the lsusb command:

$ sudo ./usbreset /dev/bus/usb/002/003  