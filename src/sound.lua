local soundlist = {
   "digsand1",
   "digsand2",
   "rockbust",
   "bigrockbust",
   "gem",
   "death",
   "headbang",
   "charged",
   "land",
   "slugland",
   "turnaround",
   "ghost",
}

local sounds = {}
local chans = {}

for k,v in ipairs(soundlist) do
   local path = string.format("sound/%s.wav", v)
   sounds[v] = love.audio.newSource(path, 'static')
end

sounds.digsand1:setVolume(0.75)
sounds.digsand2:setVolume(0.75)

local sound = {}

love.audio.setOrientation(0, 0, 1, 0, -1, 0)

function sound.play_at_xy (name, x, y)
   local sx, sy = love.graphics.transformPoint(x, y)
   sound.play(name, {x/240*2-1, y/160*2-1, 1})
end

function sound.play (name, pos)
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
end

return sound
