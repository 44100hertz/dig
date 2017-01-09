local draw = require "draw"
local tiles = require "tiles"
local actors = require "actors"
local status = require "status"

local player

local scroll, dscroll
local bg_canvas, bg_quad
local points
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

      scroll = -40
      actors.init()
      tiles.init()
      player = {x = 120, y = -40}
      actors.add(require "actors/player", player)
      points = 0
   end,

   update = function ()
      dscroll = (scroll < player.y-81 or scroll % 16 > 0) and -1 or 0
      scroll = scroll - dscroll
      points = points + (-dscroll * 10 / 16)
      tiles.update(scroll)
      actors.update(scroll)

       -- ghosts per frame per scroll
      local ghost_chance_ratio = 1 / (16 * 60 * 400)
      local ghost_chance = scroll * ghost_chance_ratio
      if math.random() < ghost_chance then
         local ghost_side = math.random()*120 + player.x > 180
         local ghost_y = math.random()*160 + 40 + scroll
         actors.add(require "actors/ghost", {y=ghost_y, left=ghost_side})
      end
   end,

   draw = function ()
      love.graphics.clear(25, 25, 25)
      love.graphics.draw(bg_canvas, bg_quad, 0, math.floor(-scroll * 0.5) % 32 - 32)
      tiles.draw(scroll)
      actors.draw()
      status.draw(math.floor(points)+5, 10, 0, 5, scroll + 5)
      draw.draw(0, -scroll)
   end,

   score = function (amt)
      points = points + amt
   end,
}
