local draw = require "draw"
local tiles = require "tiles"
local actors = require "actors"

local origin_x, origin_y = 8, 16

local bool2num = function (bool) return bool and 1 or 0 end

local loadstate = function (self, state)
   self.timer = 0
   self.state = state
end

local jump, floor, air, dig

move = function (self)
   local new_dx =
      bool2num(love.keyboard.isScancodeDown("right")) -
      bool2num(love.keyboard.isScancodeDown("left"))
   if self.dx > -1 and new_dx == -1 and self.tileon == 1 then
      actors.add({
	    class=require "actors/particle",
	    sprite=2,
	    x=self.x-4,
	    y=self.y-8,
	    flip=false,
      })
   elseif self.dx < 1 and new_dx == 1 and self.tileon == 1 then
      actors.add({
	    class=require "actors/particle",
	    sprite=2,
	    x=self.x+4,
	    y=self.y-8,
	    flip=true,
      })
   end
   self.dx = new_dx
end

jump = function (self)
   self.dx = self.dx / 2
   if self.timer == 4 then
      move(self)
      self.dy = -3
      loadstate(self, air)
   end
end

floor = function (self)
   if self.timer == 1 then
      actors.add({
	    class=require "actors/particle",
	    sprite=1,
	    x=self.x-8,
	    y=self.y-8,
      })
   end
   if self.tileon == 0 then
      loadstate(self, air)
      return
   end
   if self.timer > 4 then
      move(self)
      if love.keyboard.isScancodeDown("x") then
	 loadstate(self, dig)
      elseif love.keyboard.isScancodeDown("z") then
	 loadstate(self, jump)
      end
   end
end

air = function (self)
   if self.y % 16 < 2 and self.tileon > 0 then
      -- If collided with ground
      loadstate(self, floor)
      self.dy = 0
      self.y = math.floor(self.y / 16) * 16
   else
      -- If still in air
      self.dy = math.min(self.dy + 1/4, 2)
   end
end

local dig_anim = {1,2,3,3,4,5,6,7,8,0}
dig = function (self)
   if self.timer < 11 then
      self.frame = dig_anim[self.timer]
   else
      if self.tileon == 1 then
	 tiles.destroy(math.floor(self.x/16), math.floor(self.y/16))
	 self.y = self.y + 2
      elseif self.tileon == 0 then
	 actors.add({
	       class=require "actors/particle",
	       sprite=1,
	       dy=-1,
	       x=self.x,
	       y=self.y,
	 })
      end
      loadstate(self, air)
   end
   move(self)
end

return {
   init = function (self)
      self.dx, self.dy = 0,0
      loadstate(self, air)
      self.frame = 0
   end,

   update = function (self)
      self.tileon = tiles.collide(self.x, self.y)
      self:state()
   end,

   draw = function (self)
      draw.add(self.frame, 6, self.x - origin_x, self.y - origin_y, 1, 2)
   end
}
