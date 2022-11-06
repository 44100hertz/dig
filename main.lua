love.graphics.setDefaultFilter("nearest", "nearest")
love.filesystem.setRequirePath("src/?.lua")

local state = require "state"
local input = require "input"

local scale = 5
love.window.setMode(240*scale, 160*scale)

_G.DEBUG = {
   strings = {},
   show = function (s)
      DEBUG.strings[#DEBUG.strings+1] = s
   end,
}
_G.DEBUG = nil

function love.update ()
   input.update()
   state:update()
end

function love.draw ()
   love.graphics.push()
   love.graphics.setBlendMode("alpha", "alphamultiply")
   love.graphics.scale(scale, scale)
   state:draw()
   love.graphics.pop()
   if _G.DEBUG then
      _G.DEBUG.show(collectgarbage("count"), 200, 5)
      love.graphics.setColor(0,0,0)
      love.graphics.rectangle('fill',5,10,150,#DEBUG.strings*20+5)
      love.graphics.setColor(1,1,1)
      for i,s in ipairs(_G.DEBUG.strings) do
         love.graphics.print(s, 5, i*20)
      end
      _G.DEBUG.strings = {}
   end
end
