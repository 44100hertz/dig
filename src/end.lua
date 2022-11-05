local state = require "state"
local input = require "input"

local timer

return {
   init = function ()
      timer = 0
   end,

   update = function ()
      timer = timer + 1
      if input.hit("a") or input.hit("b") or timer == 120 then
         state.pop()
         state.pop()
         state.push(require "game")
      end
   end,

   draw = function ()
      love.graphics.setColor(1, 1, 1, 1)
      status:draw()
   end,
}
