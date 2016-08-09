---
published: true
layout: post
title: Atomthreads, active ojects
category: blog
tags: AVR, RTOS, C, programming
---

[Atomthreads](http://atomthreads.com/) is a small task scheduler with AVR, stm8 and stm32 ports available. It has the very permissive BSD licence. More about it's features [here](http://atomthreads.com/?q=node/11).

It's a preemptive scheduler with multiple priorities for threads, and it provides expected rtos features like message queues, mutexes, semaphores, timers. This post will have a buildable example project for Atmega1280/328 to get started with it(soon). (and is also intended as notes for self).

Atomthreads is very lightweight, the core is written in ANSI C, and only a very small amount of architechture specific code is required. Atomthreads uses only a single timer in it's avr port for it's system tick.

## Multithreading considerations

Some things to take care of when programming with an rtos/task scheduler such as atomthreads, chibios, freertos([list of other open source RTOSs](http://www.osrtos.com/)):

- 'Threads' cannot/should not hold CPU captive by things like continuous polling for something which might take time, like waiting for an interrupt to change the value on some flag variable.

- Functions(at least those that are common between threads) should be reentrant. Usually this means using only stack for variables, so no static or file scope/global variables. Shared resources might need control mechanisms like mutexes. More on reentrant code later.

- Care should be taken to avoid priority inversion, which usually happens when a shared resource is involved, more on this later.

- All interrupt handlers apart from the system tick interrupt which you setup at the start should be enclosed in AtomIntEnter() and AtomIntExit(FALSE), this prevents rescheduling. (There is usually something similar in other RTOSs too, check documentation).


## About priority inversion:

Priority inversion happens when a medium priority thread preempts a lower priority thread while a higher priority thread is waiting on a shared resource currently with the lower priority thread. This means that even though the higher priority thread is ready to run (provided the lower priority thread finished it's work and released control of the shared resource), the medium priority thread is executing in it's place, i.e. an inversion of priority has occurred. This can lead to hard to find/reproduce bugs.

## Reentrant code

Reentrant functions can have multiple concurrent invocations which do not interfere with each other, this is done by managing how the data is used in these. From [here](http://www.embedded.com/electronics-blogs/beginner-s-corner/4023308/Introduction-to-Reentrancy), I'll just list the three conditions for reentrant code

- It uses all shared variables in an atomic way, unless each is allocated to a specific instance of the function.

- It does not call non-reentrant functions.

- It does not use the hardware in a non-atomic way.

The first one an be taken care of in ways like not using any variables outsode of the scope of the function, using only local/auto (allocated on the stack) variables, using malloc for each instance to have it's own data area(we don't malloc in our embedded code though).

If using data, say a global variable, disable ISRs (only during the non-reentrant code parts), disabling ISRs means no context switching.

Another option is using mutexes, which are used to signal if a particular resource is in use. Atomthreads provide mutexes for our use, so do other RTOSs.

Rule 2 is obvious, if your code calls other non-reentrant code, then your code inherits the non-reentrancy.

Rule 3 can be taken care of in a similar way as when dealing with shared memory.

## Active objects

One design pattern to prevent priority inversion (and other possible issues related to coding 'naked threads') is called the '[active object](http://www.state-machine.com/doc/concepts.html#Active)' pattern. In this, the thread and the resouces it needs are encapsulated together, and the resources are not exposed by any interface. The threads act like message routers. An example of such an implementation would:
    
- encapsulate the threads along with their resources 

- use thread safe message queues provided by the rtos to send and wait upon messages to perform an action

This allows for more efficient scheduling and prevents any deadlock(possibly) or priority inversion situation.

Notice that this means that for most things each thread need not even have reentrant code, since we encapsulate all the resources a thread needs with itself and do not allow outside access. Also note we are using no other RTOS features, no mutexes, no semaphores; only message queues.

## State machine design of threads 

One good coding rule to follow while creating threads is to never wait for a particular message, instead accept and 'route' all messages, when the thread needs some kind of reply, make the other thread send a message to it's queue. There might be an internal state to the thread which is affected by the incoming message, it can be implemented in a state machine, or even better as an hierarchical state machine, so all messages are still handled while waiting on a response even if a timeout). I'm still trying to figure out how to implement such a hierarchical state machine myself.

Essentially, all threads should have exclusive access to their designated resources, and all that they should do is wait on their message queues to dispatch requests from other threads/ISRs/itself.

- If the thread to which a message had been sent, wants to reply, the mechanism in this scheme would be to send a message on the caller's message queue. 
- if a thread wants to signal itself, say of a timout or a successful operation, then it sends a message to it's own queue and it is handled like any other message.

<!-- Another simple thing could be to have a certain message which send a function pointer from one of the exported functions of the callee's thread, (and some way to pass any parameters also if any), and the function call can be thought of as being deferred, and will be run whenever the callee thread is scheduled to be run. -->
