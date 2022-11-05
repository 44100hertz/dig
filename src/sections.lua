local sections = {
   {slug_every = 5, ghosts = 0.0, rocks = 0.2, gaps = 1},
   {slug_every = 10, ghosts = 0.5, rocks = 0.8, gaps = 2},
   {slug_every = 5, ghosts = 0.5, rocks = 0.5, gaps = 2},
   {slug_every = 4, ghosts = 0.5, rocks = 0.8, gaps = 3},
   {slug_every = 3, ghosts = 0.8, rocks = 0.5, gaps = 4},
   {slug_every = 3, ghosts = 0.8, rocks = 1.0, gaps = 5},
}

function sections.section_index (row)
   return math.max(1, 1 + math.min(math.floor(row / 40), #sections))
end

function sections.section (row)
   return sections[sections.section_index(row)]
end

return sections
