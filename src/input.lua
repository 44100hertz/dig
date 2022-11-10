local input = {}

local keyBind = {
   a="x", b="z",
   du="up", dd="down",
   dl="left", dr="right"
}

local joyBind = {
   b="a", a="b",
   du="dpup", dd="dpdown",
   dl="dpleft", dr="dpright",
}

local joy = love.joystick.getJoysticks()[1]
love.joystick.loadGamepadMappings("gamecontrollerdb.txt")

local joy2hat = function (lr, ud, check)
   local dz = 0.5 --deadzone
   if check == "dl" and lr < -dz then return true end
   if check == "dr" and lr >  dz then return true end
   if check == "du" and ud < -dz then return true end
   if check == "dd" and ud >  dz then return true end
end

-- populate an array of buttons
local buttons = {}
for k,_ in pairs(keyBind) do buttons[k] = 0 end

love.keypressed = function () input.usecontroller = false end
love.joystickpressed = function () input.usecontroller = true end

function input.update ()
   local lr, ud
   if joy then
      lr = joy:getAxis(1)
      ud = joy:getAxis(2)
   end

   for k,v in pairs(keyBind) do
      if love.keyboard.isScancodeDown(v) or
         joy and joy:isGamepadDown(joyBind[k]) or
         joy and joy2hat(lr, ud, k)
      then
         if buttons[k] > -1 then
            buttons[k] = buttons[k]+1
         end
      else
         -- reset to 0 when released
         buttons[k] = 0
      end
   end
end

function input.stale ()
   for k,_ in pairs(keyBind) do buttons[k] = -1 end
end

function input.rebind (binds)
   keyBind = binds
end

function input.held (k)
   return (buttons[k] > 0)
end

function input.hit (k)
   return (buttons[k] == 1)
end

return input
