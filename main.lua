local state = require "state"
local draw = require "draw"
local game = require "game"

love.run = function ()
   love.math.setRandomSeed(os.time())
   state.push(game)

   canvas = love.graphics.newCanvas(240, 160)

   while true do
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
	 if name == "quit" then
	    if not love.quit or not love.quit() then
	       return a
	    end
	 end
	 love.handlers[name](a,b,c,d,e,f)
      end

      state.update()
      canvas:renderTo(state.draw)
      love.graphics.present()
   end
end
