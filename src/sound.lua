local soundlist = {
   "dig1", "dig2", "land"
}

local sounds = {}
local chans = {}

for k,v in ipairs(soundlist) do
   local path = string.format("sound/%s.wav", v)
   sounds[v] = love.audio.newSource(path)
end

return {
   play = function (sound, chan)
      chan = chan or 1
      if chans[chan] then chans[chan]:stop() end
      if sounds[sound] then
         chans[chan] = sounds[sound]
--         chans[chan]:play()
      end
   end
}
