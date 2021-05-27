
--While loop

i = 1
while (i <= 10) do
  io.write(i)
  i = i + 1

  -- break throws you out of a loop
  -- continue doesn't exist with Lua
  if i == 8 then break end
end
print("\n")


--Numeric for

for i=1, 10, 1 do
print(i)
end


--ipairs possible implementation

function ipairs (t)
      local i = 0
      local n = table.getn(t) --get length of array
      return function ()
               i = i + 1 --Go to next element
               if i <= n then return i, t[i] end --Check if we went out of bounds
             end
 end

--Generic for
a={"Lua", "Programming", "Language", 1, 2, 3}

for i,v in ipairs(a) --ipairs is an iterator
do
print("Index:",i,"Value:",v)
end
