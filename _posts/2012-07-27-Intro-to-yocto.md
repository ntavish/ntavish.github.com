---
published: true
layout: post
title: Intro to yocto
category: blog
---

I have been working on an ARM9 based SOM(system on module) at work.
The board can run linux, and there are a few ways to get a working 
kernel and a rootfs easily(?), for example 
[buildroot](http://buildroot.uclibc.org/)(which provides makefiles
and patched to give you a kernel and a root file system),
and [openembedded](http://www.openembedded.org/wiki/Main_Page) (this 
also helps you create a customized linux distribution).

[Yocto](http://www.yoctoproject.org) is a linux foundation project 
which is contributed to by many companies and individulas to help
developers create a complete linux system regardless of the 
hardware/architechture. With these, you can get a complete linux
system for ARM/MIPS/PowerPC/x86/x86_64. Its core on is based on 
openembedded.

If you are working on embedded hardware, getting linux running on it
(if it can, that is(sidenote: http://dmitry.co/index.php?p=./04.Thoughts/07.%20Linux%20on%208bit)) 
is a huge advantage since programming it becomes greatly simplified.

First of all you need a system running linux,you don't _need_ one
(http://www.yoctoproject.org/documentation/build-appliance) but your
work will probably be more difficult. [This](http://www.yoctoproject.org/docs/current/yocto-project-qs/yocto-project-qs.html)
gives you a quick intro to how to get your environment setup etc.
![Yocto](images/yocto.png)

After you do the `. ./oe-init-build-env TargetDir` step, you will be 
cd'd to that directory with a few scripts/program paths appended to
your $PATH. Now you can edit the local.conf file  to setup paths and parallellism etc
as is explained in the quick start guide. Now, you can do a bitbake 
core-image-minimal or something, which will start building the
minimal image for the default architecture which is x86. Only d this if you target 
is x86, since it will take HOURS and HOURS for the compilation/download of
sources even on a fast computer. [Bitbake](http://en.wikipedia.org/wiki/BitBake) is a tool which reads metadata
which is classes, configs and 'recipes', which are provided by yocto/oe,
or by you, to perform tasks, whcih can be fetch/compile/deploy/... for 
packages that you want to build. It also performs dependancy resolution.

The first main component of a linux system is the linux kernel.
	bitbake virtual/kernel
should compile the kernel for you, with the patched that are present
with yocto, or you can specify more to suit your custom board.
(to make yocto support a custom board, you can provide a BSP 'layer'
(a layer is a collection of recipes basically, read all about it http://www.yoctoproject.org/docs/current/dev-manual/dev-manual.html))
The image generated will usually be a zImage in binary, or if you have
a custo BSP, it might be something else too, which enables your board to boot.
(check your procssor's reference manual to find out!)
For example, freescale imx233 needs the image to have a specific encrypted format,
and also a specific layout for it to boot through SD/MMC, so it
provides a BSP layer for its processors https://github.com/Freescale/meta-fsl-arm. 
Other ways are also possible to boot it, and will probably need the image 
to be in a different way. You will probably need to tune kernel compilation
yourself instead of accepting the default config; to do that:
	bitbake -c menuconfig virtual/kernel
The kernel by itself won't do much, you need to have a root file system, 
which it mount on / when it boots. The minimal rootfs
	bitbake core-image-minimal
will contain a minimal working system. You yould provide the generated 
file system(which will contain the directories and files that a 
typical linux system has like /var /sys /bin /usr etc.). Yocto will
also package the things it builds for your filesystem so it is
easy to add more stuff to your rootfs. You need to find a way to make
the kernel be able to mount the rotfs. For example, if you have the 
filesystem on a SD card on the system, you need the kernel to support,
and use the SD card peripharal on your board. And you need to tell the
kernel to mount the rootfs from there using the Kernel command line.
If you are using a bootloader like u-boot, then it can pass a command 
line to the kernel, else it will have to be compiled inside the kernel.
You can do this via the menuconfig to configure the kernel, or, it
might be provided to you by your BSP via a patch of sth.

If all goes well, you should have a running linux system within a few
hours. The yocto documentation is available at:
	http://www.yoctoproject.org/documentation 
