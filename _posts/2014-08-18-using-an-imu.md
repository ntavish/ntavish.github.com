---
published: false
layout: post
title: Using an IMU
category: blog
tags: IMU, quaternions, math, vectors, 3D
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
heavy lifting and give you the quaternion orientation directly.
