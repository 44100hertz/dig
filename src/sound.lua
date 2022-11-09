local soundlist = {
   "digsand1",
   "digsand2",
   "rockbust",
   "bigrockbust",
   "gem",
   "death",
}

local sounds = {}
local chans = {}

for k,v in ipairs(soundlist) do
   local path = string.format("sound/%s.wav", v)
   sounds[v] = love.audio.newSource(path, 'static')
end

return {
   play = function (name, pos)
      if name == "digsand" then
         name = "digsand" .. (math.random() < 0.5 and '1' or '2')
      end
      if not sounds[name] then
         print('sound does not exist: ', name)
      end
      if pos then
         sounds[name]:setPosition(unpack(pos))
      end
      love.audio.stop(sounds[name])
      love.audio.play(sounds[name])
   end,
}
