local tiles = require "tiles"
local actors = require "actors"
local sound = require "sound"
local state = require "state"
local input = require "input"

local loadstate = function (self, state)
   self.timer = 1
   self.state = state
   self:state()
end

local act, move, exit
local jump, floor, air, dig, charge, crack, dead

act = function (self)
   if input.hit("b") then
      sound.play("dig1")
      loadstate(self, dig)
   elseif input.hit("a") then
      loadstate(self, jump)
   elseif
      input.hit("dd") and
      self.dx == 0 and
      self.state ~= charge
   then
      loadstate(self, charge)
   end
end

-- General function for movement
move = function (self)
   -- Set a sort of goal position
   local bool2num = function (bool) return bool and 1 or 0 end
   local new_dx =
      bool2num(input.held("dr")) -
      bool2num(input.held("dl"))

   -- Do not allow collisions with rocks
   if tiles.collide(self.x + new_dx, self.y-1)>1 then
      self.dx = 0
      return
   end

   -- Spawn movement particles
   if self.dx > -1 and new_dx == -1 and self.tileon == 1 then
      local sand = {
         sprite=2, flip=false,
         x=self.x+4, y=self.y-8,
      }
      actors.add(require "actors/particle", sand)
   elseif self.dx < 1 and new_dx == 1 and self.tileon == 1 then
      local sand = {
         sprite=2, flip=false,
         x=self.x-4, y=self.y-8,
      }
      actors.add(require "actors/particle", sand)
   end

   self.dx = new_dx
end

exit = function (self)
   if self.tileon == 0 then
      self.spin_speed = 1
      loadstate(self, air)
      self.y = self.y + 2
   else
      loadstate(self, floor)
   end
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
   -- Hitting ground
   if self.timer == 1 then
      self.fy = 6
      self.sy = 1
      self.dx, self.dy = 0,0
      self.y = math.floor(self.y * (1/16)) * 16
      sound.play("land")
      if self.tileon == 1 then
         local sand = {
            sprite=1,
            x=self.x-8, y=self.y-8,
         }
         actors.add(require "actors/particle", sand)
      end
   end

   -- Walking anim
   if self.dx < 0 then self.fx = math.floor(self.timer*0.5 % 4)
   elseif self.dx > 0 then self.fx = math.floor(-self.timer*0.5 % 4)
   else self.fx = 0
   end

   -- If not actually grounded, enter air state
   if self.tileon == 0 then
      self.spin_speed = 1
      loadstate(self, air)
      return
   end

   -- User input
   move(self)
   act(self)
end

-- In-air falling state
air = function (self)
   self.fx = 4 + math.floor(self.timer * self.spin_speed % 12)
   self.fy = 6
   self.sy = 1
   if tiles.collide(self.x + self.dx, self.y-8)>1 and self.dy < 0 then
      self.dy = -self.dy
      local bonk = {
         x=self.x-8, y=self.y-8,
         sprite=3,
      }
      actors.add(require "actors/particle", bonk)
   end
   if self.y % 16 < 2 and self.tileon > 0 and
      tiles.collide(self.x, self.y-16)<2 and self.dy > 0
   then
      -- If on potential ledge top not below a rock, and falling, land
      loadstate(self, floor)
   else
      -- If still in air
      move(self)
      self.dy = math.min(self.dy + 1/4, 2)
   end
end

-- Attempt to dig a tile below
dig = function (self)
   self.dx = 0
   if self.timer < 15 then
      local anim = {0,0,1,2,3,3,3,4,5,5,5,6,7,8,0}
      self.fx = anim[self.timer]
      self.fy = 7
      self.sy = 2
   else
      exit(self)
   end
   if self.timer == 9 then
      if self.tileon == 1 then
         sound.play("dig2")
         tiles.destroy(self.x, self.y)
      end
   end
end

crack = function (self)
   if self.timer == 1 then
      self.fx = 12
   elseif self.timer == 4 then
      self.fx = 13
   elseif self.timer == 30 then
      self.fx = 14
   elseif self.timer == 32 then
      self.fx = 15
   elseif self.timer == 34 then
      exit(self)
   end
end

charge = function (self)
   self.fy = 7
   self.sy = 2
   if not input.held("dd") then
      loadstate(self, floor)
   end
   if self.timer > 45 then
      self.fx = math.floor(self.timer / 8.0 % 2) + 10
      if input.hit("b") then
         loadstate(self, crack)
      end
   else
      self.fx = 9
   end
end

dead = function (self)
   self.sy = 1
   self.dx = 0
   if self.tileon == 0 then
      self.fx, self.fy = 8, 6
      self.dy = 1
      self.timer = 0
   elseif self.timer < 20 then
      self.dy = 0
      self.fx = math.floor(self.timer / 4.0)
      self.fy = 9
   elseif self.timer == 120 then
      state.push(require "end")
   else
      self.fx = math.floor((self.timer / 4.0) % 2) + 5
   end
end

return {
   size = 4,
   group = "player",
   priority = true,
   sx=1, sy=1,
   ox=8, oy=12,
   spin_speed = 1,
   state = air,

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
