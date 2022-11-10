local sections = {
   {slug_every = 5, ghost_every = 20, rocks = 0.2, gaps = 1.5},
   {slug_every = 20, ghost_every = 5, rocks = 0.2, gaps = 2},
   {slug_every = 10, ghost_every = 10, rocks = 0.8, gaps = 2},
   {slug_every = 4, ghost_every = 5, rocks = 0.2, gaps = 1.5},
   {slug_every = 3, ghost_every = 4, rocks = 0.2, gaps = 1.5},
   {slug_every = 2, ghost_every = 3, rocks = 1.0, gaps = 5},
}

function sections.color (row)
   local r = 1
   local g = 1
   local b = 1
   if row > 140 then
      r = math.max(0.5, 1 - row / 600)
      g = math.max(0.5, 1 - row / 1200)
   end
   return r, g, b
end

function sections.section_index (row)
   return math.max(1, 1 + math.min(math.floor(row / 50), #sections-1))
end

function sections.section (row)
   return sections[sections.section_index(row)]
end

return sections
