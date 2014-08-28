---
published: true
layout: post
title: Using an IMU
category: blog
tags: IMU, quaternions, invensense, math
---

An inertial measurement unit is a system which contains sensors(accelerometers, 
gyroscopes, magnetometers) and does something called 'sensor fusion' on the sensor 
data obtained to allow you to keep track of orientation of whatever thing you put the 
sensors on. [Orientation](http://en.wikipedia.org/wiki/Orientation_%28geometry%29) or 
attitude is how the body is placed in 3d space, more precisely it is 3d rotation(from a 
reference zero rotation of the object) which is required to reach the current placement. 
We can also keep track of the location of the object with the sensor data from the 
sensors; keeping a track of the path/trajectory of the the body is also called
'gait tracking'. If you google that, you will find some links from 
[X-io.co.uk](http://x-io.co.uk), papers and some videos from Sebastian Madgwick. He has 
also made some sample C code(and also matlab, C# etc) for the algorithm he developed 
to efficiently calculate quaternion from aceel/gyro/mag data. 

The algorithm is an optimization problem which minimizes error between calculated and 
expected output. You should consider using that if you plan to use discrete sensors(as 
opposed to using a IMU on a chip, which this post is about).

This post is about using a chip like Invensense MPU9150/MPU6050 etc. Which do most of the 
heavy lifting and give you the quaternion orientation directly. These chips are very often 
found in cellphones etc. Even oculus rift.

These chips can be used to read raw accelerometer and gyroscopes via their i2c interface,
but this is most useful when Invensense provided DMP(digital motion processor) driver is 
used. Basically, mpu9150 and others contain a processor too, iirc its an 8051, but they 
only provide a binary blob, which you have to upload to the mpu chip, after that, you can 
use its (new) i2c commands to access and set parameters/readings. Documentation is again 
provided only as sample code. (here is some barely working code for using this with a pic32 
[mpu9150-pic32](https://github.com/ntavish/mpu9150-pic32). (not using compass)

The internal sampling rate for the sensors can be in kHz, but the sampling rate we want is 
lower, so we can do other thing on our main procssor. (sleep, say in phones, to save 
battery). You can set a rate of say 50Hz, and mpu will generate an interrupt every 20ms
and you can read quaternion/accel/gyro readings(they will be downsampled to 50Hz).

First basic application for these sensors used in few smartphone games are sensing tilt, 
to say control a car in-game. What developers usually do in this application is use only 
accelerometer readings. Since these are pretty noisy, they also first apply a low pass 
filter, to smooth it out. But, this also has the side effect of adding a delay, causing 
latency which can be even percieved, and also much less sensitivity to fast motions.

The solution is to use the quaternion output, or if not available direcly, calculate it.
Why this works much better is because: accelerometers are noisy but they give give readings 
around actual value(i.e. have high frequency noise), and gyroscopes have a very nice 
output, but it drifts(i.e. even when kept stationary, it might indicate that it 
is rotating, at a slowly changing rate), or that gyroscopes have low frequency noise. 
Different sensor fusion algorithms make use of these(somehow) to counter each other's 
noise.

To do this, first you need the initial/origin quaternion value(or, quaternion at position 
which you consider to be initial). Need the initial one only to "reset" quaternion
into our preferred origin position. This is done by

	q = quaternion_multiply( q_cur, conjugate(q_origin) )

this works because to compound to rotations, we multiply the quaternions, and to reverse 
one rotation, we take the conjugate(negate the signs of components).

Now, we need to calculate tilts of x(1,0,0), y(0,1,0) and z(0,0,1) axes from the 
orientation that corresponds to quaternion q calculated above. First though, we need
to also rotate the axes, by rotation corresponding to q_origin, because that's our origin.

	x = 0 + 1i + 0j + 0k
	y = 0 + 0i + 1j + 0k
	z = 0 + 0i + 0j + 1k

	xaxix = q_origin * x * conj(q_origin)
	yaxix = q_origin * y * conj(q_origin)
	zaxix = q_origin * z * conj(q_origin)
		, all quaternion multiplications
		  also, normalize all three

This rotates x axis(1,0,0) by rotation q_origin. (quaternions output from mpu represents
relative rotation from the moment it started calculations, not absolute orientation, so we 
had to rotate our q_cur earlier by conj(q_origin)).

The angle can be calculated by:
	
	xangle = acosf(quat_dot(q, xaxis))*180/pi  , etc

This somehow gives half/(or double?) angle, have to check calculations for this. But it 
gives the angle. Much much more accurate and responsive than low passing accelerometer 
readings.

Another simple application is to use this to detect taps/thumps etc. Although mpu9150 has
code for doing this within the DMP, but it is written for(actually is in binary blob) 
smartphones to detect taps i guess? It works, but it's not very tunable and it didnt work 
in some cases, like  putting this in a box and detecting thumps, which I guess have 
different signature(on accelerometer readings) tha taps on a phone.

To do this better, read accelerometer readings for the three axes, and keep a window(last n 
values) of `ax^2, ay^2, az^2`.

For each time instant, calculate:

	energy = sqrt( summation(ax^2) + summation(ay^2) + summation(az^2) )

(can leave out sqrt).

Then apply a threshld for miniumum value.

The third is gait tracking, which is not as trivial as above, coming up shortly.