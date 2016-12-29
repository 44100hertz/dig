local draw = require "draw"

love.run = function ()
   love.math.setRandomSeed(os.time())

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

      draw.draw()
      love.graphics.present()
   end
end
