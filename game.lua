local draw = require "draw"

-- 15x10 onscreen tiles
-- 15x15 tiles loaded onscreen; 5 above you
-- tile_off says where to start, moves up with the game
-- for each tile, true = sand, false = none
local tiles = {}
local tile_off = 0
local scroll = 0

return {
   init = function ()
      for y = 0,15 do
	 tiles[y] = {}
	 for x = 0,15 do
	    tiles[y][x] = true
	 end
      end
   end,

   update = function ()
      scroll = scroll + 1
      tile_off = math.floor(scroll / 16)
      local maxoff = tile_off+15
      if not tiles[maxoff] then
	 tiles[tile_off-1] = nil
	 tiles[maxoff] = {}
	 for x = 0,15 do
	    tiles[maxoff][x] = true
	 end
      end

      local rx = math.floor(math.random() * 16)
      local ry = math.floor(math.random() * 16) + tile_off
      tiles[ry][rx] = false
   end,

   draw = function ()
      -- Draw 11 rows of tiles; max possible visible
      for y = tile_off,tile_off+11 do
      	 for x = 0,15 do
       	    local tilex = x % 2 + (tiles[y][x] and 0 or 2)
       	    local tiley = y % 2-- TODO: depth randomization
       	    draw.add(tilex, tiley, x*16, y*16)
       	 end
      end
      draw.draw(0, -scroll)
   end,
}
