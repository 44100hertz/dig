local draw = require "draw"
local tiles = require "tiles"

local origin_x, origin_y = 8, 16

return {
   init = function (self)
      self.dx, self.dy = 0,0
   end,

   update = function (self)
      local tx, ty = tiles.collide(self.x, self.y)
      if tx then
	 self.dy = 0
	 self.y = math.floor(self.y / 16) * 16
	 if love.keyboard.isScancodeDown("x") then
	    tiles.destroy(tx, ty)
	 elseif love.keyboard.isScancodeDown("z") then
	    self.dy = -2
	 end
      else
	 self.dy = math.min(self.dy + 1/8, 2)
      end

      local bool2num = function (bool) return bool and 1 or 0 end
      self.dx =
	 bool2num(love.keyboard.isScancodeDown("right")) -
	 bool2num(love.keyboard.isScancodeDown("left"))
   end,

   draw = function (self)
      draw.add(0, 6, self.x - origin_x, self.y - origin_y, 1, 2)
   end
}
