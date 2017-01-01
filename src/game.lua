local draw = require "draw"
local tiles = require "tiles"
local actors = require "actors"

local player

local scroll, dscroll
local bg_canvas, bg_quad
bg_canvas = love.graphics.newCanvas(32, 32)
bg_canvas:setWrap("repeat", "repeat")

return {
   init = function ()
      bg_canvas:renderTo(function ()
            local quad = love.graphics.newQuad(32, 32, 32, 32,
                                               draw.img:getDimensions())
            love.graphics.draw(draw.img, quad)
      end)
      
      bg_quad = love.graphics.newQuad(0, 0, 240, 160+32, 32, 32)
      scroll = -120
      tiles.init()
      actors.init()
      player = {
         class = require "actors/player",
         x = 120,
         y = -300,
      }
      actors.add(player)
   end,

   update = function ()
      dscroll = scroll < player.y-85 and -1 or 0
      scroll = scroll - dscroll
      tiles.update(scroll)
      actors.update(scroll)
   end,

   draw = function ()
      love.graphics.clear(25, 25, 25)
      love.graphics.draw(bg_canvas, bg_quad, 0, math.floor(-scroll * 0.5) % 32 - 32)
      tiles.draw()      
      actors.draw()
      draw.draw(0, -scroll)
   end,
}