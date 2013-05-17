---
published: true
layout: post
title: Some USB talk
category: blog
---

I saw Travis Goodspeed's [talk](http://www.youtube.com/watch?v=ijyAwxH_iok) on writing a USB pen drive from scratch. It was interesting how I did not see USB protocol as a network protocol earlier, with endpoints as ports as on a IP network, to communicate with an application on it. At the same time i realized that what he said about developers using a lot of code from manufacturer supplied example code or code examples from books is also true.

USB Host code on operating systems (or not operating systems) is also developed with this kind of example code in mind, which can result in interesting bugs; some of which he demonstrated in his talk. The thing is that developers on both sides (device and host) are not expecting much deviation from ideal or expected behavior. One more reason for this is that the communication protocols are layers upon layers of protocols. USB disk is USB, USB mass storage class, SCSI, block device; there might also be layers of buffering and caching on the host side.

All sorts of unexpected behavior can result if the device (or host?) misbehaves, because software is just not handling cases where the device does not follow expected behavior. This leads to possibilities like intercepting firmwares, bypassing DRM or digital signatures (as he demoed) and other such exploits. Check his blog [post](http://travisgoodspeed.blogspot.in/2012/07/emulating-usb-devices-with-python.html) about writing USB devices in python on his hardware called [facedancer](http://goodfet.sourceforge.net/hardware/facedancer21/)(goodFet earlier versions).
