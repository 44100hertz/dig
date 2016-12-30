local draw = require "draw"

-- 15x10 onscreen tiles
-- 15x15 tiles loaded onscreen; 5 above you
-- tile_off says where to start, moves up with the game
-- for each tile, true = sand, false = none
local tiles = {}
local tile_off = 0

local actors = {}

local scroll = -120

return {
   init = function ()
      for y = 0,15 do
	 tiles[y] = {}
	 for x = 0,15 do
	    tiles[y][x] = true
	 end
      end

      local player = {
	 class = require "actors/player",
	 x = 120,
	 y = -60,
      }
      player.class.init(player)
      table.insert(actors, player)
   end,

   update = function ()
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

      for k,v in ipairs(actors) do
	 if v.class.update then v.class.update(v) end
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

      for k,v in ipairs(actors) do
	 if v.class.draw then v.class.draw(v) end
      end
      draw.draw(0, -scroll)
   end,
}
