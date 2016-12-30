local draw = require "draw"
local tiles = require "tiles"
local actors = require "actors"

local player

local scroll
local dscroll

return {
   init = function ()
      scroll = -120
      tiles.init()
      actors.init()
      player = {
	 class = require "actors/player",
	 x = 120,
	 y = -60,
      }
      actors.add(player)
   end,

   update = function ()
      dscroll = scroll < player.y-80 and -2 or 0
      scroll = scroll - dscroll
      tiles.update(scroll)
      actors.update(scroll)
   end,

   draw = function ()
      tiles.draw()
      actors.draw()
      draw.draw(0, -scroll)
   end,
}
