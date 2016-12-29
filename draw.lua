local assets_img = love.graphics.newImage("assets.png")
local sb = love.graphics.newSpriteBatch(assets_img, 256, "stream")
local assets_width, assets_height = assets_img:getDimensions()

local quads = {}

return {
   -- Automagically add to the batch.
   -- Will not make multiple sized quads in the same offset.
   -- Units are in 16 pixels.
   add = function (x, y, w, h, draw_x, draw_y, flip)
      if not quads[y] then quads[y] = {} end
      if not quads[y][x] then
	 w = w or 1
	 h = h or 1
	 quads[y][x] = love.graphics.newQuad(
	    x * 16, y * 16,
	    w * 16, h * 16,
	    assets_width, assets_height
	 )
      end
      sb:add(quads[y][x], draw_x, draw_y, 0, flip and -1 or 1)
   end,

   -- Draw everything in the given sprite batch
   draw = function (x, y)
      love.graphics.draw(sb, x or 0, y or 0)
      sb:clear()
   end
}
