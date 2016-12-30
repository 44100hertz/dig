local draw = require "draw"
local tiles = require "tiles"

local origin_x, origin_y = 8, 16

local bool2num = function (bool) return bool and 1 or 0 end

local loadstate = function (self, state)
   self.timer = 0
   self.state = state
end

local jump, floor, air

move = function (self)
   self.dx =
      bool2num(love.keyboard.isScancodeDown("right")) -
      bool2num(love.keyboard.isScancodeDown("left"))
end

jump = function (self)
   if self.timer == 3 then
      move(self)
   elseif self.timer == 4 then
      self.dy = -2
      loadstate(self, air)
   end
end

floor = function (self)
   local tx, ty = tiles.collide(self.x, self.y)
   if not tx then
      loadstate(self, air)
      return
   end
   move(self)
   if love.keyboard.isScancodeDown("x") then
      tiles.destroy(tx, ty)
   elseif love.keyboard.isScancodeDown("z") then
      loadstate(self, jump)
   end
end

air = function (self)
   local tx, ty = tiles.collide(self.x, self.y)
   if tx then
      self.state = floor
      self.dy = 0
      self.y = math.floor(self.y / 16) * 16
   else
      self.dy = math.min(self.dy + 1/8, 2)
   end
end

return {
   init = function (self)
      self.dx, self.dy = 0,0
      loadstate(self, air)
   end,

   update = function (self)
      self.timer = self.timer + 1
      self:state()
   end,

   draw = function (self)
      draw.add(0, 6, self.x - origin_x, self.y - origin_y, 1, 2)
   end
}
