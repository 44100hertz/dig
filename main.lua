love.graphics.setDefaultFilter("nearest", "nearest")
love.filesystem.setRequirePath("src/?.lua")

local log = require "log"
local state = require "state"
local input = require "input"
local util = require "util"
local config = require "config"

function love.load ()
   love.window.setMode(240*config.scale, 160*config.scale)
   if os.getenv('DIG_DEBUG') then
      _G.DEBUG = {
         input = true,
         joystick = true,
         debugaudio = false,
         debuggems = false,
         player = false,
         player_invincible = false,
         strings = {},
         show = function (s, duration)
            local ser = util.serialize(s)
            local height = 1
            for _ in ser:gmatch('\n') do
               height = height + 1
            end
            DEBUG.strings[#DEBUG.strings+1] = {
               text = ser,
               height = height,
               duration = duration or 1,
            }
         end,
      }
   end
   local font = love.graphics.newFont('res/grand9k.ttf', 8, 'mono')
   love.graphics.setFont(font)
end

local time = 0
function love.update (dt)
   time = time + dt
   local framelen = 1/60
   if time >= 0 then
      time = time - framelen
      state:update()
      input.update()
   end
end

function love.draw ()
   love.graphics.push()
   love.graphics.setBlendMode("alpha", "alphamultiply")
   love.graphics.scale(config.scale, config.scale)
   state:draw()
   love.graphics.pop()

   if _G.DEBUG then
      _G.DEBUG.show(collectgarbage("count"))

      local height = 0
      for i,s in ipairs(_G.DEBUG.strings) do
         height = height + s.height
      end

      love.graphics.setColor(0,0,0)
      love.graphics.rectangle('fill',5,10,150,height*12+5)
      love.graphics.setColor(1,1,1)

      local height = 0
      local newstrs = {}
      for i,s in ipairs(_G.DEBUG.strings) do
         love.graphics.print(s.text, 5, 12*height+10)
         height = height + s.height
         s.duration = s.duration - 1
         if s.duration > 0 then
            newstrs[#newstrs+1] = s
         end
      end
      _G.DEBUG.strings = newstrs
   end
end
