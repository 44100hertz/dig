local sections = {
   {slug_every = 5, ghost_every = 10, rocks = 0.2, gaps = 1.5},
   {slug_every = 20, ghost_every = 5, rocks = 0.8, gaps = 2},
   {slug_every = 5, ghost_every = 10, rocks = 0.5, gaps = 2},
   {slug_every = 4, ghost_every = 5, rocks = 0.8, gaps = 3},
   {slug_every = 3, ghost_every = 4, rocks = 0.2, gaps = 1.5},
   {slug_every = 2, ghost_every = 3, rocks = 1.0, gaps = 5},
}

function sections.color (row)
   local r = math.max(0.5, 1 - row / 600)
   local g = math.max(0.5, 1 - row / 1200)
   local b = 1.0
   return r, g, b
end

function sections.section_index (row)
   return math.max(1, 1 + math.min(math.floor(row / 50), #sections-1))
end

function sections.section (row)
   return sections[sections.section_index(row)]
end

return sections
