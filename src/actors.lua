local actors

return {
   init = function ()
      actors = {}
   end,

   update = function (scroll)
      for k,v in ipairs(actors) do
         v.class.update(v, scroll)
         if v.dx then v.x = v.x + v.dx end
         if v.dy then v.y = v.y + v.dy end
         v.x = v.x % 240
         if v.timer then v.timer = v.timer + 1 end
      end
   end,

   draw = function ()
      for k,v in ipairs(actors) do
         if v.class.draw then v.class.draw(v) end
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
