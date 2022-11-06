local util = {}

function util.rng(num)
   return math.floor(love.math.random() * num+1) - 1
end

function util.binom()
   local sum = 0
   for _ = 1,8 do
      sum = sum + math.random()
   end
   return sum / 8
end

function util.binom_int(num)
   return math.floor(util.binom() * num)
end

return util
