# USB UART

Projects using usb serial IP . this bit bashes a USB UART.

## usb-loopback

This is a demo project which simply echoes back to the output what it receives on the input.

## vt52-fpga

https://github.com/DavidJRichards/vt52-fpga

This version is a branch targeted to run on the ebaz4205 zynq board
original readme here [readme](./vt52-fpga.md)

The original project is hosted here: [vt52-fpga](https://github.com/AndresNavarro82/vt52-fpga)

The terminal appears as a USB device 'ttyACM0' when the PL runs, it may be used as a terminal or login session.

```
sudo systemctl enable serial-getty@ttyACM0.service
sudo systemctl start serial-getty@ttyACM0.service
```

change TERM setting to VT52 by creating an overrride file for /dev/ttyACM0
```
sudo systemctl edit serial-getty@ttyACM0.service
```
Add the following lines:
```
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -- \\u' --keep-baud 115200,38400,9600 %I vt52
```


![VGA Login session](./img/USB-ttyACM0-login.jpg)


Some minor changes were needed to make the sources build with Vivado, A custom pll has been used taking the external 33.333 MHz clock to derive the 24 MHz VGA clock and 48 MHz USB clock.

The vivado tcl script v52-usb.tcl will create a project 'vt52-usb' when sourced in this directory.

There is an LED which flashes at the same rate as the VGA cursor when the PL is active.

The keyboard is a PS/2 PC keyboard with clock and data lines fed into the fpga with current limiting resistors and pull ups to 5V.

The USB interface is very simple consisting of current limiting resistors of 47R and a pull up resistor to identify the USB transfer speed. A separate output is used to pull the D+ line high through 2k2 to identify full speed USB, an internal pull up on D+ may be used instead.

![USB interface](./img/USB-UART-interface2.jpg)

USB info: https://www.beyondlogic.org/usbnutshell/usb2.shtml#Electrical

## keyboard changes for UK PS/2

see here for scancodes used in set2 column.
http://www.quadibloc.com/comp/scan.htm

Cursor keys now send upper case ESC codes (was lower case)

## display font characters

Simple program to show printable characters in fpga font:

```C
#include <stdio.h>
#include <string.h>

int main(void)
{
   int i,j,k,n;
   char s[8];
   k=0;
   
   printf("\n\r   ");
   for(n=0;n<16;n++)
      printf("%4X",n);
      
   printf("\n\r     ");
   for(n=0;n<16;n++)
      printf("%s","----");
      
   for(i=0;i<16;i++)
   {
      printf("\n\r%3X |",k);
      for (j=0;j<16;j++)
      {
         switch(k){
         case 7:
            strcpy(s,"tab");
            break;
         
         case 8:
            strcpy(s,"bs ");
            break;
         
         case 10:
            strcpy(s,"nl ");
            break;
            
         case 27:
           strcpy(s,"esc");
            break;

         case 127:
            strcpy(s,"del");
            break;
            
         case 13:
            strcpy(s,"cr ");
            break;

         case 9:
         case 12:
         case 11:
         case 15:
         case 26:
            *s=0;
            break;
         
         case 0:
         case 1:
         case 2:
         case 3:
         case 4:
         case 5:
         case 6:
         case 14:
         case 16:
         case 17:
         case 18:
         case 19:
         case 20:
         case 21:
         case 22:
         case 23:
         case 24:
         case 25:
         case 28:
         case 29:
         case 30:
         case 31:
            *s=0;
         break;
         
         default:       
            sprintf(s,"%c ",k);
            break;
         } /* end case */
         printf("%3.3s",s);
         k++;
         printf("|");
      } /* end j */
   } /* end i */
   printf("\n\r     ");
   for(n=0;n<16;n++)
      printf("%s","----");
   printf("\n\r   ");
   return 0;
}
```

![dispchars](./img/dispchars.jpg)



