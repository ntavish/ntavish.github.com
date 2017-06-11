---
published: true
layout: post
title: Security in embedded systems
category: blog
---

These are some notes I had about the topic of security in embedded systems, and things of which I knew of but don't know in enough detail yet

    Internet of things is the nightmare of pervasive embedded insecurity made real - Taylor swift (@SwiftOnSecurity)

* ### Why is it important
    * embedded devices are in places which are likely to be hidden from sight and work without as much intervention/interaction as other tech (desktop applications, websites)
    * we also have cars which are connected to the internet now(have remote firmware updates), also fridges, and TVs with mics and cameras
    * supposedly secure tech/service/device might be compromised due to underlying insecurity in an embedded device in the path
    * how important it should be to you would depend on how much is at stake (privacy, security of other systems dependant on this)

* ### Why is it hard
    * security is hard in general, for embedded systems it is even more harder
    * firmware upgrades not always easy/possible
    * on-device passwords / keys need to be stored properly; devices often have default passwords which never get changed
    * older, and scarier recent side channel attacks. Power analysis, extracting keys from ambient EMI etc. from improper crypto or hardware peculiarities
    * software bugs


* ### Cases in the wild
    * http://qz.com/789970/krebs-ddos-akamai-akam-a-massive-attack-that-may-have-hijacked-online-cameras-could-soon-be-the-new-normal/
    * routers are regularly found to have big security issues, this can be really bass since routers are part of your infrastructure which other things use. See SOHOpelesdly broken
    * recently tp-link locked their firmware because of fcc change in rules regarding firmware which can be modified by customers, which is an issue because this prevents users patching hardware that is running in their own networks
    * http://www.theregister.co.uk/2015/03/05/broadband_routers_sohopeless_and_vendors_dont_care/
    * SCADA systems 
    * http://www.devttys0.com/blog/  http://routersecurity.org/
    * http://www.bbc.com/news/technology-28208905 lightbulb leaks wifi passwords
    * Chinese camera with built in p2p features communicates with dozens of ips despite the option to disable p2p on, on by default, vulnerable

* ### Common pitfalls
    * using deprecated crypto, ex. WEP for WiFi, TLS versions which are no longer supported because of not being strong enough
    * common pitfalls of not sanitizing input
    * RNG issues, using sources with low entropy, predictable entropy, or sources which can be tricked (?)
        * esp8266 early firmware use constant seed for rng
    * insufficient key lengths in encryption
    * no encyption, or some obfuscation in name of encyption
    * ciphers used improperly (RC4 in WEP, xbox etc.), insecure hash functions, md5 no longer considered secure etc.
    * leaving private keys inside devices same across all devices (depends on how secure system needs to be)

* ### Basics of security
    * do not use homebrew crypto, it means don't create own ways of authentication, or implement your own encryption cipher
    * use standard/public/peer reviewed cryptography, not proprietary/new/your own
    * do not use otherwise secure crypto libraries or functions in a non standard, non recommended way.
    * "A cryptosystem should be secure even if everything about the system, except the key, is public knowledge."
    * obscurity does not add to security
    * http://www.edn.com/design/systems-design/4410267/1/The-Right-and-Wrong-Way-to-Implement-Cryptographic-Algorithms-in-Embedded-Electronic-Systems
    * Stanfor's cryptography course is a good place to learn about cryptography https://www.coursera.org/learn/crypto

* ### Suggestions for most common use cases
    * good coding practices to reduce the 3 most common errors resulting in bugs:buffer overflows, unchecked input, poor handling of integer type checks
        * always sanitize input
        * follow a coding standard maybe? MISRA-C
        * decouple, modules, reduce the amount of state the program has, minimize 'globals'
        * famous apple bug, "goto fail; goto fail;"
        * use fixed width integral types, uint8_t, uint32_t, int16_t etc. because int char long are allowed to be implementation defined by ISO C
    * rng
        * use hardware rng if available
        * of not use enough entropy. Example adc noise, use only LSB, xor with differences in click, LEB again, multiple readings, pass through some one way hash function recommended, etc.
    * https://en.wikipedia.org/wiki/Defensive_programming
    * OWASP is a really good resource for web application security guidelines, but security in writing software in general too. It had it's problems though, it is not at all newbie friendly, the content is not very regulated, so good advice might be mixed in with bad advice.
        * they have an embedded security project that is really low in activity, maybe a new resource for general advice can be started
