---
published: true
layout: post
title: Programming the miniSTM32 board
category: blog
---

This is about Programming the miniSTM32 board(on linux), which is a stm32f103ve based avaluation board.

![The miniStm32 board](/images/miniSTM32.jpg "The miniSTM32 board")

This board can be programmed using its serial port(and needs a botton connection to reset the board 
too), so these steps are quite general and shoud work accross boards and processors in similar families.

First of all you need the supportng documentation to know about the board. 

* [miniSTM32 schematic](https://docs.google.com/open?id=0B51mYat-a_5lLUhsRWN6dFpYNUU)
* [STM32F103VE reference manual](https://docs.google.com/open?id=0B51mYat-a_5lR0pRUWNFdEJxZXc)
* [STM32F103VE datasheet](https://docs.google.com/open?id=0B51mYat-a_5ldDI5U2hLc0J6VEE)
* [STM32F103VE programming manual](https://docs.google.com/open?id=0B51mYat-a_5lR0VKWW45NU5JeWc)

Skim through these...

....10 hour break....

Now download the stm32f1xx standard peripheral library, which contains CMSIS, the standard periph. library
example code, and some template projects. Look at some of the code in this to understand how the libraries are 
structured. (Actually, dont download it, download [miniSTM32 board support package][http://code.google.com/p/ministm32-bsp/), 
which aleady contains it, nd a few more things). What a bsp does is, prvide you files with board specific defines, functions etc. which
you would otherwise have to do on your own.

Also you need a cross compiler toolchain to compile code with. I use the Codesourcery g++ lite toolchain
from Mentor graphics. Be sure to download the arm-none-eabi toolchain.

Now, look at the XS3 header in the board schematic; that is the large JTAG connector header on the board and you can see its 
orientation by looking for the continuos ground connections on the other of the board. The pin we are interested in is the nRST
pin(or even the JRS pin I think). This pin can be used to reset the board; so connect it to a press button,(other end to GND). The other thing we are interested is the BOOT0 pin of
stm32f103, which is used to select the boot memory; look at the connections, and the reference manual. This is connected to the 
jumper besides the USB port. Remove it and press the reset button to make the board boot into system memory, which contains
the bootloader. Now you can use [stm32flash](http://code.google.com/p/stm32flash/) to upload code to the board.
