local draw = require "draw"
local tiles = require "tiles"
local actors = require "actors"
local status = require "status"
local sections = require "sections"

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
   player = {x = 120, y = -40}
   actors.add(require "actors/player", player)
   points = 0
end

function game.reset_score ()
   status:init()
end

function game.update ()
   if scroll >= 0 then
      points = points + (-dscroll * 10 / 16)
   end
   dscroll = (scroll < player.y-81 or scroll % 16 > 0) and -1 or 0
   scroll = scroll - dscroll
   tiles.update(scroll)
   actors.update(scroll)

   -- ghosts per frame per scroll

   local section = sections.section(scroll/16)
   if math.random() < section.ghosts / 90 then
      local ghost_side = math.random()*120 + player.x > 180
      local ghost_y = math.random()*160 + 40 + scroll
      actors.add(require "actors/ghost", {y=ghost_y, left=ghost_side})
   end

   status:update(points, player.y/16)
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

   love.graphics.push()
   love.graphics.translate(0, -scroll)
   draw.draw(0, -scroll)
   if _G.DEBUG then
      actors.draw_hitboxes()
   end
   love.graphics.pop()

   status:draw(points, player.y / 16)
end

function game.is_over ()
   return player:is_dead()
end

function game.score (amt)
   points = points + amt
end

return game
