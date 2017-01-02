local draw = require "draw"

local actors

return {
   init = function ()
      actors = {}
   end,

   update = function (scroll)
      for _,v in ipairs(actors) do
         if v.class.update then
            v.class.update(v, scroll)
         end
         if v.x then
            if v.dx then v.x = v.x + v.dx end
            if v.dy then v.y = v.y + v.dy end
         end
         if v.timer then v.timer = v.timer + 1 end
      end
   end,

   draw = function ()
      for _,v in ipairs(actors) do
         if v.class.draw then v.class.draw(v) end
         if v.fx then
            local ox = v.ox or 0
            local oy = v.oy or 0
            draw.add(v.fx, v.fy, v.x-ox, v.y-oy, v.sx, v.sy, v.flip)
         end
      end
      for k,v in ipairs(actors) do
         if v.die then table.remove(actors, k) end
      end
   end,

   add = function (actor)
      actor.class.init(actor)
      table.insert(actors, actor)
   end,
}
