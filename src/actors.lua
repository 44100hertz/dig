local draw = require "draw"

local actors

local collide = function (a, b)
   if a.class.size and b.class.size then
      local sq = function (x) return x*x end
      if sq(a.class.size + b.class.size) > sq(a.x-b.x) + sq(a.y-b.y) then
         a.class.collide(a, b)
         b.class.collide(b, a)
      end
   end
end

local draw_one = function (v)
   if v.class.draw then v.class.draw(v) end
   if v.fx then
      local ox = v.ox or 0
      local oy = v.oy or 0
      draw.add(v.fx, v.fy, v.x-ox, v.y-oy, v.sx, v.sy, v.flip)
   end
end

return {
   init = function ()
      actors = {}
   end,

   update = function (scroll)
      for i = 1,#actors do
         for j = i+1,#actors do
            collide(actors[i], actors[j])
         end
      end
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
      for k,v in ipairs(actors) do
         if v.die then table.remove(actors, k) end
      end
   end,

   draw = function ()
      for _,v in ipairs(actors) do
         if not v.class.priority then draw_one(v) end
      end
      for _,v in ipairs(actors) do
         if v.class.priority then draw_one(v) end
      end
   end,

   add = function (actor)
      actor.class.init(actor)
      table.insert(actors, actor)
      return actor
   end,
}
