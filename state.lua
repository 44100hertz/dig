local stack = {}

return {
   push = function (new_state, ...)
      table.insert(stack, new_state)
      new_state.init(...)
   end,

   pop = function ()
      if not stack[1] then
	 love.quit()
      else
	 table.remove(stack)
      end
   end,

   update = function ()
      stack[#stack].update()
   end,

   draw = function ()
      stack[#stack].draw()
   end
}
