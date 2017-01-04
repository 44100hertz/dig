local draw = require "draw"

local actors

local collide = function (a, b)
   if a.size and b.size then
      local sq = function (x) return x*x end
      if sq(a.size + b.size) > sq(a.x-b.x) + sq(a.y-b.y) then
         a:collide(b)
         b:collide(a)
      end
   end
end

local draw_one = function (v)
   if v.draw then v:draw() end
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
         if v.update then
            v:update(scroll)
         end
         if v.x then
            v.x = v.x + v.dx
            v.y = v.y + v.dy
         end
         v.timer = v.timer + 1
      end
      for k,v in ipairs(actors) do
         if v.die then table.remove(actors, k) end
      end
   end,

   draw = function ()
      for _,v in ipairs(actors) do
         if not v.priority then draw_one(v) end
      end
      for _,v in ipairs(actors) do
         if v.priority then draw_one(v) end
      end
   end,

   add = function (class, actor)
      if not class.__index then class.__index = class end
      setmetatable(actor, class)
      if actor.init then actor:init() end
      if not actor.dx then actor.dx = 0 end
      if not actor.dy then actor.dy = 0 end
      actor.timer = 0
      table.insert(actors, actor)
   end,
}
