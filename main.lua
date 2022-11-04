love.graphics.setDefaultFilter("nearest", "nearest")
love.filesystem.setRequirePath("src/?.lua")

local state = require "state"
local game = require "game"
local input = require "input"

love.window.setMode(240*5, 160*5)

_G.DEBUG = true

local lastf

function love.load ()
   state.push(game)
end

function love.update ()
   input.update()
   state.update()
   local f = love.keyboard.isScancodeDown("f")
   if f and not lastf then
      if love.window.getFullscreen() == true then
         love.window.setFullscreen(false)
      else
         love.window.setFullscreen(true)
      end
   end
   lastf = f
   love.graphics.print(collectgarbage("count"), 200, 5)
end

function love.draw ()
   love.graphics.push()
   love.graphics.setBlendMode("alpha", "alphamultiply")
   love.graphics.scale(5, 5)
   state.draw()
   love.graphics.pop()
end
