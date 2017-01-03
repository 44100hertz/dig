local tiles = require "tiles"
local actors = require "actors"
local sound = require "sound"

local bool2num = function (bool) return bool and 1 or 0 end

local loadstate = function (self, state)
   self.timer = 0
   self.state = state
end

local move, jump, floor, air, dig

-- General function for movement
move = function (self)
   -- Set a sort of goal position
   local new_dx =
      bool2num(love.keyboard.isScancodeDown("right")) -
      bool2num(love.keyboard.isScancodeDown("left"))

   -- Do not allow collisions with rocks
   if tiles.collide(self.x + new_dx, self.y-1)>1 then
      self.dx = 0
      return
   end

   -- Spawn movement particles
   if self.dx > -1 and new_dx == -1 and self.tileon == 1 then
      actors.add({
            class=require "actors/particle", sprite=2,
            x=self.x+4, y=self.y-8, flip=false,
      })
   elseif self.dx < 1 and new_dx == 1 and self.tileon == 1 then
      actors.add({
            class=require "actors/particle", sprite=2,
            x=self.x-4, y=self.y-8, flip=true,
      })
   end

   self.dx = new_dx
end

-- Lag state before a jump
jump = function (self)
   self.dx = 0
   if self.timer == 4 then
      move(self)
      self.dy = -3
      self.spin_speed = 0.5
      loadstate(self, air)
   end
end

-- Grounded
floor = function (self)
   -- Hitting ground animation
   if self.timer == 1 then
      self.dx, self.dy = 0,0
      self.y = math.floor(self.y * (1/16)) * 16
      sound.play("land")
      if self.tileon == 1 then
         actors.add({class=require "actors/particle",
                     sprite=1,
                     x=self.x-8, y=self.y-8,
         })
      end
   end

   -- If not actually grounded, enter air state
   if self.tileon == 0 then
      self.spin_speed = 1
      loadstate(self, air)
      return
   end

   -- User input
   move(self)

   if self.dx < 0 then self.fx = math.floor(self.timer*0.5 % 4)
   elseif self.dx > 0 then self.fx = math.floor(-self.timer*0.5 % 4)
   else self.fx = 0
   end
   self.fy = 6
   self.sy = 1

   if self.timer > 8 then
      if love.keyboard.isScancodeDown("x") then
         sound.play("dig1")
         loadstate(self, dig)
      elseif love.keyboard.isScancodeDown("z") then
         loadstate(self, jump)
         self:state()
      end
   end
end

-- In-air falling state
air = function (self)
   self.fx = 4 + math.floor(self.timer * self.spin_speed % 12)
   self.fy = 6
   self.sy = 1
   move(self)
   if self.timer == 3 and tiles.collide(self.x, self.y-8)>1 then
      self.dy = -self.dy
      actors.add({
            class=require "actors/particle",
            sprite=3,
            x=self.x-8,
            y=self.y-8,
      })
   end
   if self.y % 16 < 2 and self.tileon > 0 and
      tiles.collide(self.x, self.y-16)<2 and self.dy > 0
   then
      -- If on potential ledge top not below a rock, and falling, land
      loadstate(self, floor)
   else
      -- If still in air
      self.dy = math.min(self.dy + 1/4, 2)
   end
end

-- Attempt to dig a tile below
dig = function (self)
   local anim = {0,0,1,2,3,3,3,4,5,5,5,6,7,8,0}
   if self.timer < 15 then
      self.fx = anim[self.timer]
      self.fy = 7
      self.sy = 2
   else
      if self.tileon == 0 then
         self.spin_speed = 1
         loadstate(self, air)
         self.y = self.y + 2
      else
         loadstate(self, floor)
      end
   end
   if self.timer == 9 then
      if self.tileon == 1 then
         sound.play("dig2")
         tiles.destroy(self.x, self.y)
      end
   end
   self.dx = 0
end

local dead = function (self)
   self.dx = 0
   if not self.tileon then
      self.fx, self.fy = 8, 6
      self.dy = 2
      self.timer = 0
   elseif self.timer < 20 then
      self.dy = 0
      self.fx = math.floor(self.timer / 4.0)
      self.fy = 9
   else
      self.fx = math.floor((self.timer / 4.0) % 2) + 5
   end
end

return {
   size = 4,
   group = "player",
   priority = true,
   init = function (self)
      self.dx, self.dy = 0,0
      self.sx, self.sy = 1,1
      self.ox, self.oy = 8, 12
      self.spin_speed = 1
      loadstate(self, air)
   end,

   update = function (self)
      self.tileon = tiles.collide(self.x, self.y)
      self:state()
      self.x = math.max(self.x, 1)
      self.x = math.min(self.x, 240)
   end,

   collide = function (self, with)
      if self.state ~= dead then
         loadstate(self, dead)
      end
   end
}
