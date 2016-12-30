-- JuicyHoboBear: what you need to do is have it like in your mp4 you linked, split the screen up into 3 and fold them away revealing the level when you die/start a new map

local draw = require "draw"
local actors = require "actors"

-- 15x10 onscreen tiles
-- 15x15 tiles loaded onscreen; 5 above you
-- tile_off says where to start, moves up with the game
-- for each tile, true = sand, false = none
local tiles = {}
local tile_off = 0

return {
   init = function ()
      for y = 0,15 do
	 tiles[y] = {}
	 for x = 0,15 do
	    tiles[y][x] = true
	 end
      end
   end,

   update = function (scroll)
      tile_off = math.floor(scroll / 16)
      local maxoff = tile_off+15
      -- If tiles are offscreen, generate more
      if not tiles[maxoff] then
	 tiles[tile_off-1] = nil
	 tiles[maxoff] = {}
	 for x = 0,15 do
	    tiles[maxoff][x] = true -- TODO: proper tile generation
	 end
      end
   end,

   draw = function ()
      -- Draw 11 rows of tiles; max possible visible
      for y = tile_off,tile_off+11 do
	 if tiles[y] then for x = 0,15 do
	       local tilex = x % 2 + (tiles[y][x] and 0 or 2)
	       local tiley = y % 2-- TODO: depth randomization
	       draw.add(tilex, tiley, x*16, y*16)
       	 end end
      end
   end,

   destroy = function (x, y)
      tiles[y][x] = false
      local puff = {
	 class = require "actors/sandpuff",
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
      if tiles[ty] and tiles[ty][tx] then
	 return tx, ty
      end
   end
}
