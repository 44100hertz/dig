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

function util.serialize (value, indent_level, seen)
   seen = seen or {}
   indent_level = indent_level or 1
   local indent_size = 3
   if type(value) == 'table' then
      if seen[value] then
         return '<<Recursive Value>>'
      end
      seen[value] = true
      local indent_string = string.rep(' ', indent_level * indent_size)
      local lines = {}
      lines[#lines+1] = '{'
      for k,v in pairs(value) do
         lines[#lines+1] = string.format('%s[%s] = %s,',
                                         indent_string,
                                         util.serialize(k, indent_level+1, seen),
                                         util.serialize(v, indent_level+1, seen))
      end
      lines[#lines+1] = (' '):rep((indent_level-1) * indent_size) .. '}'
      return table.concat(lines, '\n')
   elseif type(value) == 'string' then
      value = string.gsub(value, [[\]], [[\\]])
      value = string.gsub(value, "'", [[\']])
      return "'" .. value .. "'"
   elseif type(value) == 'number' then
      return tostring(value)
   elseif type(value) == 'nil' then
      return 'nil'
   elseif type(value) == 'boolean' then
      return value and 'true' or 'false'
   else
      return string.format('<<Value of type %s>>', type(value))
   end
end

return util
