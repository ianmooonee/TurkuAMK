## Task 1
**Objective: study what shared libraries your executable "lab2" requires**

The executable is located in the root directory of the raspi. It is an ELF 32-bit LSB.  
The executable seems to be using 2 libraries:
- linux-vdso.so.1
- libc.so.6

## Task 2
**Objective: identify all C runtime libraries in your development setup (VM and raspi)**

VM:
- /usr/lib/x86_64-linux-gnu/libc-2.31.so  
ELF 64-bit LSB  
version 9.4.0.  

- /var/lib/schroot/chroots/rpizero-buster-armhf/usr/lib/arm-linux-gnueabihf/libc-2.28.so  
ELF 32-bit LSB  
version 8.3.0.  

- /var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/lib/arm-linux-gnueabihf/libc.so.6  
ELF 32-bit LSB  
version 12.2.0.  

- /home/student/opt/x-tools/armv8-rpi3-linux-gnueabihf/armv8-rpi3-linux-gnueabihf/sysroot/lib/libc.so.6  
ELF 32-bit LSB  
version 13.2.0.  

- /snap/snapd/20671/lib/x86_64-linux-gnu/libc-2.23.so  
ELF 64-bit LSB  
version 5.4.0 20160609.  

- /snap/core22/1033/usr/lib/x86_64-linux-gnu/libc.so.6  
ELF 64-bit LSB  
version 11.4.0.  

Raspi:
- /usr/lib/arm-linux-gnueabihf/libc.so.6  
ELF 32-bit LSB  
version 12.2.0.