local sounds = {
   dig1 = love.audio.newSource("sound/dig1.wav"),
   dig2 = love.audio.newSource("sound/dig2.wav"),
   land = love.audio.newSource("sound/land.wav"),
}

local chans = {}

return {
   play = function (sound, chan)
      chan = chan or 1
      if chans[chan] then chans[chan]:stop() end
      if sounds[sound] then
         chans[chan] = sounds[sound]
         chans[chan]:play()
      end
   end
}
