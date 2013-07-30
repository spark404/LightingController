LightingController
==================

Little Mac OS X tools to send MIDI control command to an Avolite Pearl Expert Titan

Designed to work with the MIDI trigger setup "Classic Pearl MIDI Triggers".

Set playback page
program change command 0xCn 0xpp
n = channel
pp = page number 0 - 30

Turn on a playback
note on command 0x9n 0xpp 0xll
n = channel
pp = playback number 0 - 14
ll = key velocity 0 - 127

Triggering chaces
after touch command 0xAn 0xpp 0xcc
n = channel
pp = playback number 0-19
cc = command 
  0x00 stop
  0x01 run
  0x02 repeat from step 1
  0x03 fade to next with fade time
  0x04 direct to next step
  
See Pearl Export Titan v6.0 Manual pages 167-170


