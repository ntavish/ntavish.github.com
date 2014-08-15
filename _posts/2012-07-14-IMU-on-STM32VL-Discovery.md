---
published: true
layout: post
title: IMU on STM32VL-Discovery
category: projects
tags: IMU, arduino, C, stmicro, dsp
---

I had previously built an IMU implementation on an arduino (processing
onboard(not satisfactory), or on a real computer). It was actually based on
[Sebastian Madgwick's](http://www.x-io.co.uk/node/8) Ph.D research. I was 
actually working on a kalman filter based algorithm for inertial measurement
when his paper was made available online thrugh IEEE. It was easy to understand,
easy to implement, fast and had good results. So the only logical step for me 
was to use his work and then feel bad later about not doing anything significant.

In the end I had to use the arduino just for sampling (at about 500Hz) and
do al the processing on the computer. The performance was really good, though 
I could use a magnetometer for the yaw drift. Now I have started working on 
making this work on an STM32VL-Discovery board that I had lying around.
Have to figure out getting ADC's to work. And since I might need to debug 
float i tried getting the UART working, which did seem to work, its only 
that the GPIOs are 3.3V and didnt seem to work well with the arduino which I 
was using as a serial bridge. I could use the same cube displaying thing from
the arduino code.

![stm32vl-disovery](images/stm32vldiscovery.jpg)
