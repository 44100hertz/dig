-- JuicyHoboBear: what you need to do is have it like in your mp4 you linked, split the screen up into 3 and fold them away revealing the level when you die/start a new map

local draw = require "draw"
local actors = require "actors"
local sound = require "sound"
local sections = require "sections"
local util = require "util"

local sand = {}
local binds = {}
local tile_off = 0
local slug_y

-- bind an actor to a given space, notify them when destroyed
local bind = function (x, y, actor)
   if not binds[y] then binds[y] = {} end
   binds[y][x] = actor
end

local gen_row = function (row)
   local section_index = sections.section_index(row)
   local section = sections[section_index]

   sand[row] = {}
   sand[row-40] = nil
   for i = 0,15 do
      sand[row][i] = (section_index-1) % 3 + 1
   end

   -- Gaps, 0
   local num_gaps = util.rng(section.gaps)
   for _ = 1,num_gaps do
      local col = util.rng(15)
      if sand[row-1] and sand[row-1][col] > 0 then
         sand[row][col] = 0
      end
   end

   -- Rocks, 2
   local num_rocks = util.binom_int(8 * section.rocks)
   local big_rock = row > 1 and num_rocks >= 4
   if big_rock then num_rocks = num_rocks - 4 end
   for _ = 1,num_rocks do
      sand[row][util.rng(15)] = 5
   end

   -- Sometimes make big rocks, 9 10 11 12
   if big_rock then
      local x = util.rng(14)+1 -- Find a valid x pos
      if sand[row][x] < 9 -- Check if usable spaces
         and sand[row][x-1] < 9
         and sand[row-1][x] < 9
         and sand[row-1][x-1] < 9
      then
         sand[row-1][x-1] = 9
         sand[row-1][x] = 10
         sand[row][x-1] = 11
         sand[row][x] = 12
      end
   end

   -- Gems, 3 4 5
   local gem_x = util.rng(15)
   if math.random() < 1/8 and sand[row] and sand[row][gem_x]>0 then
      local gem = {
         x=gem_x*16, y=row*16,
         kind=math.min(2, math.floor(math.random() * row / 50))
      }
      actors.add(require "actors/gem", gem)
      bind(gem_x, row, gem)
   end

   -- Generate 1 slug every N rows
   if row > 5 and row % section.slug_every == 0 then
      slug_y = util.rng(section.slug_every) + row
   end
   if row == slug_y then
      local slug_x = util.rng(15)
      if sand[row] and sand[row][slug_x]<5 then
         local slug = {
            x=slug_x*16, y=row*16,
         }
         actors.add(require "actors/slug", slug)
      end
   end
end

local draw_tile = function(x, y)
   local s = sand[y][x]
   local tx, ty = x*16, y*16
   if s == 1 then -- Sand
      draw.add(x%2, y%2, tx, ty)
   elseif s == 2 then
      draw.add(x%2, y%2+2, tx, ty)
   elseif s == 3 then
      draw.add(x%2, y%2+4, tx, ty)
   elseif s == 5 then -- Rock
      draw.add(4, 0, tx, ty)
   elseif s == 9 then -- Big rock
      draw.add(5, 0, tx, ty)
   elseif s == 10 then
      draw.add(6, 0, tx, ty)
   elseif s == 11 then
      draw.add(5, 1, tx, ty)
   elseif s == 12 then
      draw.add(6, 1, tx, ty)
   end
end

local tiles = {}

function tiles.init ()
   sand = {}
   binds = {}
   for y = 0,15 do gen_row(y, 0) end
end

function tiles.update (scroll)
   tile_off = math.floor(scroll / 16)
   local maxoff = tile_off+15
   -- If sand are offscreen, generate more
   if not sand[maxoff] then
      sand[tile_off-1] = nil
      gen_row(maxoff)
   end

   if _G.DEBUG and _G.DEBUG.debuggems then
      DEBUG.show('Gems:')
      for x,row in pairs(binds) do
         for y,_ in pairs(row) do
            DEBUG.show({x=x, y=y})
         end
      end
   end
end

function tiles.draw (scroll)
   -- Draw 11 rows of sand; max possible visible
   for y = tile_off,tile_off+11 do
      if sand[y] then
         for x = 0,15 do
            draw_tile(x, y, scroll)
         end
      end
   end
end

function tiles.destroy (x, y)
   x = math.floor(x / 16)
   y = math.floor(y / 16)
   if sand[y][x] > 0 and sand[y][x] < 5 then
      sound.play_at_xy("digsand", x*16, y*16)
      tiles.break_one(x, y)
   elseif sand[y][x] == 5 then
      sound.play_at_xy("rockbust", x*16, y*16)
      tiles.break_one(x, y, true)
   elseif sand[y][x] > 5 then
      sound.play_at_xy("bigrockbust", x*16, y*16)
      local startx = sand[y][x] == 9 and x or x-1
      for xx = startx, startx+1 do
         for yy = y, y+1 do
            tiles.break_one(xx, yy, true)
         end
      end
   end
end

function tiles.break_one (x, y, is_rock)
   if is_rock then
      for _ = 1,10 do
         actors.add(require "actors/particle", {x=x*16, y=y*16, fy=4})
      end
   else
      local particle = { x=x*16, y=y*16, fy=0, lifetime=20 }
      actors.add(require "actors/particle", particle)
   end
   sand[y][x] = 0
   if binds[y] and binds[y][x] then
      binds[y][x]:destroy()
      binds[y][x] = nil
      if #binds[y] == 0 then binds[y] = nil end
   end
end

-- test collision, assumes 16x16 object with corner at x, y
-- returns the tile that was collided with
function tiles.collide (x, y)
   x = math.floor(x/16)
   y = math.floor(y/16)
   return sand[y] and sand[y][x] or 0
end

return tiles
