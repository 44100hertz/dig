local tiles = require "tiles"
local actors = require "actors"
local sound = require "sound"
local state = require "state"
local input = require "input"

local player = {
   hbox={x=-2, y=-4, w=5, h=2},
   group = "player",
   priority = true,
   sx=1, sy=1,
   ox=8, oy=12,
   spin_speed = 1,
}

function player:enter_state (name)
   self.timer = 1
   self.state = self[name]
   self:state()
end

-- General function for movement
function player:move ()
   -- Set a sort of goal position
   local bool2num = function (bool) return bool and 1 or 0 end
   local new_dx =
      bool2num(input.held("dr")) -
      bool2num(input.held("dl"))

   -- Do not allow collisions with rocks
   if tiles.collide(self.x + new_dx, self.y-1)>4 then
      self.dx = 0
      return
   end

   -- Spawn movement particles
   if self.dx > -1 and new_dx == -1 and self.tileon == 1 then
      local sand = {
         fy=2, flip=false, dx=0.5,
         x=self.x+4, y=self.y-8,
      }
      actors.add(require "actors/particle", sand)
   elseif self.dx < 1 and new_dx == 1 and self.tileon == 1 then
      local sand = {
         fy=2, flip=true, dx=-0.5,
         x=self.x-4, y=self.y-8,
      }
      actors.add(require "actors/particle", sand)
   end

   self.dx = new_dx
end

-- Lag state before a jump
function player:jump ()
   self.dx = 0
   if self.timer == 4 then
      self:move()
      self.dy = -3
      self.spin_speed = 0.5
      self:enter_state "air"
   end
end

-- Grounded
function player:floor ()
   -- Hitting ground
   if self.timer == 1 then
      self.fy = 6
      self.sy = 1
      self.dx, self.dy = 0,0
      self.y = math.floor(self.y * (1/16)) * 16
--      sound.play("land")
      if self.tileon == 1 then
         local sand = {
            fy=1, priority=true,
            x=self.x-8, y=self.y-4,
         }
         actors.add(require "actors/particle", sand)
      end
   end

   -- Walking anim
   if self.dx < 0 then self.fx = math.floor(self.timer*0.5 % 4)
   elseif self.dx > 0 then self.fx = math.floor(-self.timer*0.5 % 4)
   else self.fx = 0
   end

   -- If not actually grounded, enter_state air state
   if self.tileon == 0 then
      self.spin_speed = 1
      self:enter_state "air"
      return
   end

   -- User input
   self:move()

   -- Grounded actions
   if input.held("b") and self.y % 16 == 0 then
      self:enter_state "dig"
   elseif input.hit("a") then
      self:enter_state "jump"
   elseif
      input.held("dd") and
      self.dx == 0 and
      self.state ~= self.charge
   then
      self:enter_state "charge"
   end
end

-- In-air falling state
function player:air ()
   self.fx = 4 + math.floor(self.timer * self.spin_speed % 12)
   self.fy = 6
   self.sy = 1

   if tiles.collide(self.x + self.dx, self.y-8)>4 and
      self.dy < 0 and self.timer > 4
   then
      -- Bonk on rocks
      sound.play('headbang', {self.x/240*2-1, 1, 0})
      self.dy = -self.dy
      local bonk = {
         x=self.x-8, y=self.y-8,
         fy=3,
      }
      actors.add(require "actors/particle", bonk)
   end
   if self.tileon>0 and self.y % 16 < 3 and
      tiles.collide(self.x, self.y-16)<5 and self.dy > 0
   then
      -- If on potential ledge top not below a rock, and falling, land
      self:enter_state "land"
   else
      -- If still in air
      self:move()
      self.dy = math.min(self.dy + 1/4, 2)
   end
end

-- Attempt to dig a tile below
function player:dig ()
   self.dx = 0
   local anim = {0,1,2,3,4,4,5,5,6,6,6,6,6,7,8,8,8}
   if self.timer <= #anim then
      self.fx = anim[self.timer]
      self.fy = 7
      self.sy = 2
   else
      if self.broketile then
         if input.held 'b' then
            self.y = self.y + 3
         end
         self.spin_speed = 1
         self:enter_state "air"
      else
         self:enter_state "floor"
         sound.play('headbang', {self.x/240*2-1, 1, 0})
      end
   end
   if self.timer == 9 then
      if self.tileon > 0 and self.tileon < 5 then
         self.broketile = true
         tiles.destroy(self.x, self.y)
      else
         self.broketile = false
      end
   end
end

function player:crack ()
   if self.timer == 1 then
      self.fx = 12
   elseif self.timer == 4 then
      tiles.destroy(self.x, self.y)
      self.fx = 13
   elseif self.timer == 30 then
      self.fx = 14
   elseif self.timer == 32 then
      self.fx = 15
   elseif self.timer == 34 then
      self:enter_state "floor"
   end
end

function player:charge ()
   self.fy = 7
   self.sy = 2
   if not input.held("dd") then
      self:enter_state "floor"
   end
   if self.timer > 30 then
      self.fx = math.floor(self.timer / 8.0 % 2) + 10
      if input.hit("b") then
         self:enter_state "crack"
      end
   else
      self.fx = 9
   end
end

function player:dead ()
   self.sy = 1
   self.dx = 0
   if self.timer == 1 then
      sound.play'death'
   end
   if self.tileon == 0 then
      self.fx, self.fy = 8, 6
      self.dy = 1
      self.timer = 0
   elseif self.timer < 20 then
      self.dy = 0
      self.fx = math.floor(self.timer / 4.0)
      self.fy = 9
   else
      self.fx = math.floor((self.timer / 4.0) % 2) + 5
   end
end

function player:is_dead ()
   return self.state == self.dead and self.timer >= 120
end

function player:update ()
   self.tileon = tiles.collide(self.x, self.y)
   self:state()
   self.x = math.max(self.x, 1)
   self.x = math.min(self.x, 240)
end

function player:collide ()
   if self.state ~= self.dead then
      self:enter_state "dead"
   end
end

player.state = player.air

return player
