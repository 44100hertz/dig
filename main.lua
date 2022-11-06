love.graphics.setDefaultFilter("nearest", "nearest")
love.filesystem.setRequirePath("src/?.lua")

local state = require "state"
local input = require "input"

love.window.setMode(240*5, 160*5)

_G.DEBUG = false

function love.update ()
   input.update()
   state:update()
   love.graphics.print(collectgarbage("count"), 200, 5)
end

function love.draw ()
   love.graphics.push()
   love.graphics.setBlendMode("alpha", "alphamultiply")
   love.graphics.scale(5, 5)
   state:draw()
   love.graphics.pop()
end
