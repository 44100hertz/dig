local config = require 'config'

local input = {
   controlMode = 'keyboard',
   touches = {},
}
local touchOverlay = love.graphics.newImage('res/touchoverlay.png')
-- https://github.com/gabomdq/SDL_GameControllerDB/blob/master/gamecontrollerdb.txt
love.joystick.loadGamepadMappings("res/gamecontrollerdb.txt")

local buttons = {
   a = 0,
   b = 0,
   dl = 0,
   dr = 0,
   dd = 0,
}
local hit = {}
local joystick = false

local keyBind = {
   x='a', up='a',
   z='b',
   down='dd',
   left='dl',
   right='dr',
}

local joyBind = {
   x='a',
   y='b',
   b='a',
   a='b',
   dpdown='dd',
   dpleft='dl',
   dpright='dr',
}

local joy2hat = function (lr, ud, check)
   local dz = 0.5 --deadzone
   if check == "dl" and lr < -dz then return true end
   if check == "dr" and lr >  dz then return true end
   if check == "du" and ud < -dz then return true end
   if check == "dd" and ud >  dz then return true end
end

function bdown(b, source)
   if b then
      buttons[b] = buttons[b] + 1
      hit[b] = true
   end
   if DEBUG and DEBUG.input then
      DEBUG.show(string.format('pressed %s from %s', b, source), 30)
   end
end

function bup(b, source)
   if b then
      buttons[b] = buttons[b] - 1
   end
   if DEBUG and DEBUG.input then
      DEBUG.show(string.format('pressed %s from %s', b, source), 30)
   end
end


love.keypressed = function (_, scancode)
   input.controlMode = 'keyboard'
   bdown(keyBind[scancode], 'key')
end
love.keyreleased = function (_, scancode)
   bup(keyBind[scancode], 'key')
end

love.gamepadpressed = function (_, button)
   if DEBUG and DEBUG.joystick then
      DEBUG.show(string.format('joybutton: %s', button), 30)
   end
   input.controlMode = 'joystick'
   bdown(joyBind[button], 'joy')
end
love.gamepadreleased = function (_, button)
   if DEBUG and DEBUG.joystick then
      DEBUG.show(string.format('joybutton: %s', button), 30)
   end
   bup(joyBind[button], 'joy')
end

-- -- Touch -- --
-- Touch button up -- releasing touch rock break presses 'B'
function tbup(button)
   if button == 'dd' then
      hit.b = true
   end
   bup(button)
end
love.touchpressed = function (id, mx, my)
   input.controlMode = 'touch'
   mx = mx / config.scale
   my = my / config.scale
   local button = input.getTouchButton(mx, my)
   input.touches[id] = button
   bdown(button, 'touch')
end
love.touchmoved = function (id, mx, my)
   mx = mx / config.scale
   my = my / config.scale
   local prevButton = input.touches[id]
   local button = input.getTouchButton(mx, my)
   if prevButton ~= button then
      tbup(prevButton)
      input.touches[id] = button
      bdown(button, 'touch')
   end
end
love.touchreleased = function (id)
   tbup(input.touches[id], 'touch')
   input.touches[id] = nil
end

function input.update ()
   local lr, ud
   if joy then
      lr = joy:getAxis(1)
      ud = joy:getAxis(2)
   end

   for k,_ in pairs(buttons) do
      hit[k] = false
      if joy and joy2hat(lr, ud, k) then
         joystick = k
      end
   end

   if DEBUG and DEBUG.input then
      DEBUG.show(buttons)
      DEBUG.show(hit)
      DEBUG.show(input.touches)
   end
end

function input.getTouchButton(mx, my)
   local keys = {
      {'dl', 0, 113, 23, 31},
      {'dr', 25, 113, 23, 31},
      {'dd', 183, 117, 23, 22},
      {'a', 208, 104, 31, 23},
      {'b', 208, 129, 31, 23},
   }
   function inrect(mx, my, x, y, w, h)
      return
         mx >= x and mx <= (x+w) and
         my >= y and my <= (y+h)
   end
   for i,params in ipairs(keys) do
      local key, x, y, w, h = unpack(params)
      if inrect(mx, my, x, y, w, h) then
         return key
      end
   end
   return nil
end

function input.stale ()
   for k,_ in pairs(buttons) do buttons[k] = 0 end
end

function input.rebind (binds)
   keyBind = binds
end

function input.held (k)
   return buttons[k] > 0 or joystick == k
end

function input.hit (k)
   return hit[k]
end

function input.drawTouchOverlay ()
   love.graphics.setColor(1,1,1,0.5)
   love.graphics.draw(touchOverlay)
   love.graphics.setColor(1,1,1,1)
end

return input
