local draw = require "draw"
local tiles = require "tiles"

-- 15x10 onscreen tiles
-- 15x15 tiles loaded onscreen; 5 above you
-- tile_off says where to start, moves up with the game
-- for each tile, true = sand, false = none

local actors = {}
local player

local scroll = -120
local dscroll

return {
   init = function ()
      tiles.init()

      player = {
	 class = require "actors/player",
	 x = 120,
	 y = -60,
      }
      player.class.init(player)
      table.insert(actors, player)
   end,

   update = function ()
      dscroll = scroll < player.y-80 and -1 or 0
      scroll = scroll - dscroll

      tiles.update(scroll)

      for k,v in ipairs(actors) do
	 if v.class.update then v.class.update(v) end
      end
   end,

   draw = function ()
      tiles.draw()

      for k,v in ipairs(actors) do
	 if v.class.draw then v.class.draw(v) end
      end

      draw.draw(0, -scroll)
   end,
}
