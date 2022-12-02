local game = require "game"
local status = require "status"
local input = require "input"
local sound = require "sound"

local state = {
   state = 'title',
   timer = 0,
}

function state:set_state (name)
   self.state = name
   self.timer = 0
end

function state:update ()
   self.timer = self.timer + 1
   if self.state == 'title' then
      if self.timer == 1 then game.init() end
      if love.keyboard.isScancodeDown 'return' or input.hit'a' or
         next(love.touch.getTouches())
      then
         sound.play'start'
         self:set_state 'ingame'
      end
   elseif self.state == 'ingame' then
      if self.timer == 1 then game.reset_score() end
      game.update()
      if game.is_over() then
         self:set_state 'gameover'
      end
   elseif self.state == 'gameover' then
      if self.timer == 240 then
         self:set_state 'title'
         self:update()
      end
   end
end

function state:draw ()
   game.draw()
   if self.state == 'gameover' then
      local red = math.max(0, 2-self.timer/120)
      love.graphics.setColor(red, 0, 0, self.timer/120)
      love.graphics.rectangle("fill",0,0,240,160)
      love.graphics.setColor(1,1,1)
   end
   status:draw()
end

return state
