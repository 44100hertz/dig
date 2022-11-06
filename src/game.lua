local util = require "util"
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
local ghost_timer = 0
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
   local section = sections.section(scroll/16)

   if scroll >= 0 then
      points = points + (-dscroll * 10 / 16)
   end
   dscroll = (scroll < player.y-81 or scroll % 16 > 0) and -1 or 0
   scroll = scroll - dscroll
   tiles.update(scroll)
   actors.update(scroll)

   ghost_timer = ghost_timer - 1
   if ghost_timer <= 0 then
      local ghost_side = math.random()*120 + player.x > 180
      local ghost_y = math.random()*160 + 40 + scroll
      actors.add(require "actors/ghost", {y=ghost_y, left=ghost_side})
      ghost_timer = util.binom() * section.ghost_every * 60
   end

   status:update(points, player.y/16)
end

function game.draw ()
   love.graphics.clear(0,0,0)
   love.graphics.draw(bg_canvas, bg_quad, 0, math.floor(-scroll * 0.5) % 32 - 32)
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
   love.graphics.setColor(sections.color(scroll/16))
   tiles.draw(scroll)
   draw.draw()
   love.graphics.setColor(1,1,1,1)
   actors.draw()
   draw.draw()
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

game.plot = [[ You are an AI gardening bot, the Kawaii crab model. Your owner
has passed away, and they tossed you into a junk yard. But just as you were
about to be crushed, a piece of debris fell down and turned you back on. So, you
integrated back into society. But, work is a lot of trouble these days -- they
just don't have a good use for you, wath a market full of of cuter products
which have left you outdated. Determined to prove your worth, you found your way
into a gem mine -- one which has been abandoned due to the presence of
machinery-eating slugs from Mars, as well as electromagnetic spirits which can
easily fry your circuits. Foolish crab! How deep can you dig? ]]

return game
