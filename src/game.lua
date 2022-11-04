local draw = require "draw"
local tiles = require "tiles"
local actors = require "actors"
local status = require "status"

local player

local scroll, dscroll
local bg_canvas, bg_quad
local controls_quad
local points
bg_canvas = love.graphics.newCanvas(32, 32)
bg_canvas:setWrap("repeat", "repeat")

local game = {}

function game.init ()
   title_freeze = true
   bg_canvas:renderTo(function ()
         local quad = love.graphics.newQuad(32, 32, 32, 32,
                                            draw.img:getDimensions())
         love.graphics.draw(draw.img, quad)
   end)
   bg_quad = love.graphics.newQuad(0, 0, 240, 160+32, 32, 32)

   scroll = -240
   actors.init()
   tiles.init()
   status:init()
   player = {x = 120, y = -40}
   actors.add(require "actors/player", player)
   points = 0
end

function game.update ()
   if title_freeze then
      title_freeze = not love.keyboard.isScancodeDown('return')
      return
   end
   if scroll >= 0 then
      points = points + (-dscroll * 10 / 16)
   end
   dscroll = (scroll < player.y-81 or scroll % 16 > 0) and -1 or 0
   scroll = scroll - dscroll
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
end

function game.draw ()
      love.graphics.clear(0,0,0)
      love.graphics.draw(bg_canvas, bg_quad, 0, math.floor(-scroll * 0.5) % 32 - 32)
      tiles.draw(scroll)
      actors.draw()
      if (scroll < 100) then
         -- Title
         draw.add(10, 9, 24, -210, 6, 3, false, true)
         if love.timer.getTime() % 1 < 0.5 then
            -- enter prompt
            draw.add(10, 12, 24, -120, 6, 1)
         end
         draw.add(10, 2, 82, -64, 6, 3)
      end
      draw.draw(0, -scroll)
      status:draw(points, player.y / 16)
end

function game.score (amt)
   points = points + amt
end

return game
