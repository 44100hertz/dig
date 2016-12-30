-- JuicyHoboBear: what you need to do is have it like in your mp4 you linked, split the screen up into 3 and fold them away revealing the level when you die/start a new map

local draw = require "draw"
local actors = require "actors"

-- 15x10 onscreen tiles
-- 15x15 tiles loaded onscreen; 5 above you
-- tile_off says where to start, moves up with the game
-- for each tile, true = sand, false = none
local sand = {}
local tile_off = 0

local rng = function (num)
   return math.floor(math.random() * num+1)
end

local gen_row = function ()
   local row = {}
   for i = 0,15 do row[i] = 1 end
   num_rocks = rng(2)
   num_gaps = rng(2)
   for _ = 1,num_rocks do row[rng(15)] = 2 end
   for _ = 1,num_gaps do row[rng(15)] = 0 end
   return row
end

local draw_tile = function(x, y)
   if sand[y][x] == 1 then
      draw.add(x%2, y%2, x*16, y*16)
   elseif sand[y][x] == 0 then
      draw.add(x%2+2, y%2, x*16, y*16)
   elseif sand[y][x] == 2 then
      draw.add(4, 2, x*16, y*16)
   end
end

return {
   init = function ()
      for y = 0,15 do
	 sand[y] = gen_row()
      end
   end,

   update = function (scroll)
      tile_off = math.floor(scroll / 16)
      local maxoff = tile_off+15
      -- If sand are offscreen, generate more
      if not sand[maxoff] then
	 sand[tile_off-1] = nil
	 sand[maxoff] = gen_row()
      end
   end,

   draw = function ()
      -- Draw 11 rows of sand; max possible visible
      for y = tile_off,tile_off+11 do
	 if sand[y] then
	    for x = 0,15 do
	       draw_tile(x, y)
	    end
	 end
      end
   end,

   destroy = function (x, y)
      sand[y][x] = 0
      local puff = {
	 class = require "actors/particle",
	 sprite = 0,
	 dy = -1,
	 x = x * 16,
	 y = y * 16,
      }
      actors.add(puff)
   end,

   -- test collision, assumes 16x16 object with corner at x, y
   -- returns the tile that was collided with
   collide = function (x, y)
      local tx = math.floor(x/16)
      local ty = math.floor(y/16)
      return sand[ty] and sand[ty][tx] or 0
   end
}
