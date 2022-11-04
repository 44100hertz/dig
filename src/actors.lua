local draw = require "draw"

local actors = {}
local actor_list = {}

function actors.init ()
   actor_list = {}
end

function actors.update (scroll)
   for i = 1,#actor_list do
      for j = i+1,#actor_list do
         actors.collide(actor_list[i], actor_list[j])
      end
   end
   for _,v in ipairs(actor_list) do
      if v.update then
         v:update(scroll)
      end
      if v.x then
         v.x = v.x + v.dx
         v.y = v.y + v.dy
      end
      v.timer = v.timer + 1
   end
   for k,v in ipairs(actor_list) do
      if v.die then table.remove(actor_list, k) end
   end
end

function actors.calc_hitbox (a)
   local x = a.x + (a.hbox.x or 0)
   local y = a.y + (a.hbox.y or 0)
   return x, y, a.hbox.w, a.hbox.h
end

function actors.collide (a, b)
   if a.hbox and b.hbox then
      local w = a.hbox.w + b.hbox.w
      local h = a.hbox.h + b.hbox.h
      local ax, ay = actors.calc_hitbox(a)
      local bx, by = actors.calc_hitbox(b)
      if w > math.abs(ax - bx) and h > math.abs(ay - by) then
         a:collide(b)
         b:collide(a)
      end
   end
end

function actors.draw ()
   for _,v in ipairs(actor_list) do
      if not v.priority then actors.draw_one(v) end
   end
   for _,v in ipairs(actor_list) do
      if v.priority then actors.draw_one(v) end
   end
end

function actors.draw_one (v)
   if v.draw then v:draw() end
   if v.fx then
      local ox = v.ox or 0
      local oy = v.oy or 0
      if v.flip then ox = -ox end
      draw.add(v.fx, v.fy, v.x-ox, v.y-oy, v.sx, v.sy, v.flip)
   end
end

function actors.draw_hitboxes ()
   for _,v in ipairs(actor_list) do
      if (v.hbox) then
         local x, y, w, h = actors.calc_hitbox(v)
         love.graphics.setColor(1, 0, 0)
         love.graphics.rectangle('line',x, y, w, h)
      end
   end
   love.graphics.setColor(1, 1, 1)
end

function actors.add (class, actor)
   if not class.__index then class.__index = class end
   setmetatable(actor, class)
   if actor.init then actor:init() end
   if not actor.dx then actor.dx = 0 end
   if not actor.dy then actor.dy = 0 end
   actor.timer = 0
   table.insert(actor_list, actor)
end

return actors
