love.filesystem.setRequirePath("src/?.lua")

local state = require "state"
local game = require "game"

love.window.setMode(240*3, 160*3)

local lastf

love.run = function ()
   love.math.setRandomSeed(os.time())
   state.push(game)

   love.graphics.setDefaultFilter("nearest", "nearest")
   local canvas = love.graphics.newCanvas(240, 160)

   while true do
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
         if name == "quit" then
            if not love.quit or not love.quit() then
               return a
            end
         end
         love.handlers[name](a,b,c,d,e,f)
      end

      love.graphics.setBlendMode("alpha", "alphamultiply")
      state.update()
      canvas:renderTo(state.draw)
      love.graphics.setBlendMode("replace", "premultiplied")
      love.graphics.draw(canvas, 0, 0, 0, 3, 3)
      love.graphics.present()

      local f = love.keyboard.isScancodeDown("f")
      if f and not lastf then
         if love.window.getFullscreen() == true then
            love.window.setFullscreen(false)
         else
            love.window.setFullscreen(true)
         end
      end
      lastf = f
   end
end
