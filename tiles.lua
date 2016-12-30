-- JuicyHoboBear: what you need to do is have it like in your mp4 you linked, split the screen up into 3 and fold them away revealing the level when you die/start a new map

local draw = require "draw"
local actors = require "actors"

-- 15x10 onscreen tiles
-- 15x15 tiles loaded onscreen; 5 above you
-- tile_off says where to start, moves up with the game
-- for each tile, true = sand, false = none
local sand = {}
local tile_off = 0

return {
   init = function ()
      for y = 0,15 do
	 sand[y] = {}
	 for x = 0,15 do
	    sand[y][x] = true
	 end
      end
   end,

   update = function (scroll)
      tile_off = math.floor(scroll / 16)
      local maxoff = tile_off+15
      -- If sand are offscreen, generate more
      if not sand[maxoff] then
	 sand[tile_off-1] = nil
	 sand[maxoff] = {}
	 for x = 0,15 do
	    sand[maxoff][x] = true -- TODO: proper tile generation
	 end
      end
   end,

   draw = function ()
      -- Draw 11 rows of sand; max possible visible
      for y = tile_off,tile_off+11 do
	 if sand[y] then for x = 0,15 do
	       local tilex = x % 2 + (sand[y][x] and 0 or 2)
	       local tiley = y % 2-- TODO: depth randomization
	       draw.add(tilex, tiley, x*16, y*16)
       	 end end
      end
   end,

   destroy = function (x, y)
      sand[y][x] = false
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
      if sand[ty] and sand[ty][tx] then
	 return tx, ty
      end
   end
}
