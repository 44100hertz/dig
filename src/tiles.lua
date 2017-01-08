-- JuicyHoboBear: what you need to do is have it like in your mp4 you linked, split the screen up into 3 and fold them away revealing the level when you die/start a new map

local draw = require "draw"
local actors = require "actors"
local sound = require "sound"

local sand = {}
local binds = {}
local tile_off = 0

local rng = function (num)
   return math.floor(love.math.random() * num+1) - 1
end

local binom_rng = function (num)
   local sum = 0
   for _ = 1,8 do
      sum = sum + math.random()
   end
   return math.floor(sum * num * (1/8))
end

-- bind an actor to a given space, notify them when destroyed
local bind = function (x, y, actor)
   if not binds[y] then binds[y] = {} end
   binds[y][x] = actor
end

local gen_row = function (row)
   sand[row] = {}
   for i = 0,15 do sand[row][i] = math.min(binom_rng(row / 50), 2)+1 end

   -- Rocks, 2
   local num_rocks = binom_rng(math.min(row/16+1, 8))
   for _ = 1,num_rocks do sand[row][rng(15)] = 5 end

   -- Gaps, 0
   local num_gaps = binom_rng(math.min(row/16+2, 5))
   for _ = 1,num_gaps do sand[row][rng(15)] = 0 end

   -- Sometimes make big rocks, 9 10 11 12
   if binom_rng(math.min(row / 8), 18) > 10 then
      local x = rng(14)+1 -- Find a valid x pos
      if sand[row][x] < 2 -- Check if usable spaces
         and sand[row][x-1] < 2
         and sand[row-1][x] < 2
         and sand[row-1][x-1] < 2
      then
         sand[row-1][x-1] = 9
         sand[row-1][x] = 10
         sand[row][x-1] = 11
         sand[row][x] = 12
      end
   end

   -- Gems, 3 4 5
   local gem_x = rng(15)
   if math.random() < 1/8 and sand[row] and sand[row][gem_x]>0 then
      local gem = {
         x=gem_x*16, y=row*16,
         kind=math.min(2, math.floor(math.random() * row / 50))
      }
      actors.add(require "actors/gem", gem)
      bind(gem_x, row, gem)
   end
   local slug_x = rng(15)
   if row > 5 and math.random() < row / 1000 + 1/10
      and sand[row] and sand[row][slug_x]<5
   then
      local slug = {
         x=slug_x*16, y=row*16,
      }
      actors.add(require "actors/slug", slug)
   end
end

local draw_tile = function(x, y)
   local s = sand[y][x]
   local tx, ty = x*16, y*16
   if s == 1 then -- Sand
      draw.add(x%2, y%2, tx, ty)
   elseif s == 2 then
      draw.add(x%2, y%2+2, tx, ty)
   elseif s == 3 then
      draw.add(x%2, y%2+4, tx, ty)
   elseif s == 5 then -- Rock
      draw.add(4, 0, tx, ty)
   elseif s == 9 then -- Big rock
      draw.add(5, 0, tx, ty)
   elseif s == 10 then
      draw.add(6, 0, tx, ty)
   elseif s == 11 then
      draw.add(5, 1, tx, ty)
   elseif s == 12 then
      draw.add(6, 1, tx, ty)
   end
end

return {
   init = function ()
      for y = 0,15 do gen_row(y, 0) end
   end,

   update = function (scroll)
      tile_off = math.floor(scroll / 16)
      local maxoff = tile_off+15
      -- If sand are offscreen, generate more
      if not sand[maxoff] then
         sand[tile_off-1] = nil
         gen_row(maxoff, scroll)
      end
   end,

   draw = function ()
      -- Draw 11 rows of sand; max possible visible
      for y = tile_off,tile_off+11 do
         if sand[y] then
            for x = 0,15 do
               draw_tile(x, y, scroll)
            end
         end
      end
   end,

   destroy = function (x, y)
      x = math.floor(x / 16)
      y = math.floor(y / 16)
      if sand[y][x] > 0 and sand[y][x] < 5 then
         sound.play("dig2")
         local particle = { x=x*16, y=y*16, fy=0, lifetime=20 }
         actors.add(require "actors/particle", particle)
      elseif sand[y][x] > 4 then
         -- play rock breaking sound
         -- spawn rock particles
         for _ = 1,10 do
            actors.add(require "actors/particle", {x=x*16, y=y*16, fy=4})
         end
      end
      sand[y][x] = 0
      if binds[y] and binds[y][x] then
         binds[y][x]:destroy()
      end
   end,

   -- test collision, assumes 16x16 object with corner at x, y
   -- returns the tile that was collided with
   collide = function (x, y)
      x = math.floor(x/16)
      y = math.floor(y/16)
      return sand[y] and sand[y][x] or 0
   end,
}
