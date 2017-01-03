local timer

return {
   init = function ()
      timer = 0
   end,

   update = function ()
      timer = timer + 1
   end,

   draw = function ()
      love.graphics.setBlendMode("multiply")
      love.graphics.setColor(254, 254, 254)
      love.graphics.rectangle("fill",0,0,240,160)
   end,
}
