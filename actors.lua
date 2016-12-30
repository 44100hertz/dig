local actors

return {
   init = function ()
      actors = {}
   end,

   update = function (scroll)
      for k,v in ipairs(actors) do
	 v.class.update(v, scroll)
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
   end
}
