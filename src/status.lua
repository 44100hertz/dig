local draw = require "draw"

return {
   draw = function (num, offx, offy, x, y)
      local s = string.format(num)
      local off0 = string.byte("0")
      local i = 0
      for i = 1,s:len() do
         local coffx = (s:byte(i)-off0) * 0.5
         if coffx < 0 then coffx = 5 end
         draw.add(coffx + offx, offy, x+i*8, y, 0.5, 0.5)
      end
      draw.add(15.5, 0, x+s:len()*8+8, y, 0.5, 0.5)
   end
}
