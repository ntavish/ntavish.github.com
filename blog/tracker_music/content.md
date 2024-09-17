<zero-md><script type="text/markdown">
# Tracker music

**Dated**: 2024/09/17

I am a forever begineer at music making. I've dabbled at making music in several different
ways, earliest ones being actual instruments like a violin bought from Lajpat Rai market
(which was missold to me, it was a 3/4 size violin, too small for me at 19), or several
flutes, which I do think I was okay at, maybe; or a ukulele, which I gave away to a cousin
after it was left sitting in Delhi for a few months while I was in Bangalore.

I've also dabbled in electronic music at the same time, during my uni days I was more
interested in the sound design and synthesis part of it more than making actual music
so I used to play with many software synths, and even programmed a few of 'my own'.

Those small instruments that I made were things I learnt on the online book on stanford.edu: 
[Physical Audio Signal Processing](https://ccrma.stanford.edu/~jos/pasp/pasp.html) by Julius O. Smith III.

It was super interesting, and while I learnt some things, it wasn't much, and definitely not
much music. I later made one electronic board which could do MIDI, and was working on some
software synthesis, but I abandoned the project (as we do); maybe this what installed the longing
in me for some music making thingy that is handheld, and I can say I had some part in its making.
(this continues still, with me trying to often find companies which do this and are looking
for engineers)

With the small collection of accumulated music gear I have: a few MIDI instruments, a
synthesizer, some softwares (DAWs, VSTs and such), I made a few small number of musical
things when I was at the peak of my motivation and while life otherwise allowed me time
to dabble in such things, but it was at most a bit of pain making tracks. I could make
nice sounds but making it into even a 1 minute track is difficult (and I continue to learn
how to understand, and replicate musical ideas, which make me a little bit better now).

That's enough boring story, which wasn't really needed, back to the topic. I had acquired a
small handheld retro video game emulator thing (rg35xx), and was playing around with it a few
months ago, and I saw somewhere a video of a person making music on an actual Gameboy Color
on this software called [LSDJ](https://www.littlesounddj.com/lsd/index.php), and it looks like
this:

![LSDJ homepage screenshot](lsdj.png)

This was amazing, and this led me into a rabbit hole about music tracker software. I
knew Aphex Twin and others used some weird software to make some of his music, but this
was the first time I really saw what it really was.

Aftern that, I then spent some time learning my way through making short loops on another
piece of software called LittleGPTracker, or [little piggy tracker](https://www.littlegptracker.com/)
as it's commonly known. It's user interface and screen layout is inspired from LSDJ. It
was a fun experience being able to make something resembling parts of a track in a small
handheld device. And it was faster, and more convenient, even though it wasn't really the
type of music I really wanted to make. People, who are skilled at this sort of thing 
could probably use it to make almost any style of music, be it chiptunes (which was
probably most common), metal, house, dance, whatever, but I had a little bit of
a wishlist when it came to actually making the sounds I wanted it to make (even though
I was/am barely qualified as a user if based on output or number of hours spent).

I wanted at least some synths to be present on the tracker, somehow, that was the biggest
perhaps, maybe some more big/small wishes as well. Enter the M8 tracker from [Dirtywave](https://dirtywave.com/).
It has everything I wished and what I did not know I wished or was even possible to have
in such a constrained (and constraining) package. And no I did not buy it (yet), I've
been able to play with it basically the same as if I had an actual device, with the
M8 headless firmware, which is a binary you can get from the dirtywave website, and run
it on a Teensy 4.1 board and you can have basically the same device (you connect it
to a computer for the screen and input though USB serial/audio/midi through the teensy
USB port).

![M8 tracker](m8.png)

I've been spending some happy hours making some sounds on this headless set up with my
laptop, and it's been great. No need to be sitting on my desktop which is the only
computer I have which has Ableton live (lite), or spend time fiddling most of the time
with settings, synths, sound design etc., you just start making things from the get go
and since you just don't have so many options, what you focus on is important. I've also
started actually using samples, for the first time really, apart from simply always
defaulting to using synths for everything (maybe drumkits were an exception).

All in all, this is actually one way of making music I am actually excited about. I've
tried (only a little) some desktop based music trackers, but haven't gotten good results
like with M8 yet, and I see missing synth engine as something of a miss, when I compare
it to the M8. (I'm talking about things like renoise here)

Huge respect to Trash80 for making this exceptional piece of hardware/software, and even
more so for releasing M8 headless (as a try-before-you-buy, but M8 production is a bit
slow at the moment and it is hard to get a hold of).

If we look at the hardware and software used to build the M8 device, that's also super
interesting to me. M8 website says it based on a Teensy 4.1, but that's a development
board, which is based on the NXP RT1062. I think the reason they specifically mention
Teensy here, is because how good the teensy ecosystem is, especially with regards to
the [Teensy audio library](https://www.pjrc.com/teensy/td_libs_Audio.html). I myself
have not really used it, but have seen the page and the video a long time ago, and 
_thought_ about using it because it just seemed like a super quick way to build an
audio device, chaing together effects, and filters and such.

I am not certain if M8 uses the arduino core (or the teensy arduino core), but I can
atleast see from messages in discord that some of the libraries used are arduino
libraries, and the same OOP style as used by arduino libraries is used. I think that
speaks volumes for not considering arduino (the ecosystem) as a toy thing. It is simply
C++ code, with very well designed interfaces (which is why there are 'cores' for all
sorts of MCUs and their peripherals), while still following the usual embedded needs
like only static allocation etc. (additionally the C++ used in arduino and here disables
some langauge features to make it more suitable to embedded environments like no RTTI,
no exceptions).

Another interesting inclusion in the firmware is the inclusion of the open source Mutable
systems [Braids](https://pichenettes.github.io/mutable-instruments-documentation/modules/braids/)
synthesis engine. There are several other types of synthesis engines, and I'm still discovering
how to make intersting instruments with them. When combined with the built in 'tables', they
become even more powerful. This kind of thing is simply not present on other tracker like
software.

Hopefully next post related to this will contain some music I make with this (or some other
way).

</script></zero-md>

