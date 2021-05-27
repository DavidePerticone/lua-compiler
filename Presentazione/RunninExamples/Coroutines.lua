-- Use create to create one that performs some action
co = coroutine.create(function()   --Anonymous functions
  for i = 1, 10, 1 do
  print(i)
  print(coroutine.status(co))
  if i == 5 then coroutine.yield() end
  end end)

-- They start off with the status suspended
print(coroutine.status(co))

-- Call for it to run with resume during which the status changes to running
coroutine.resume(co)

print(22222)

print(coroutine.status(co))

--Resume after i==5
coroutine.resume(co)

-- After execution it has the status of dead
print(coroutine.status(co))


co2 = coroutine.create(function()
  for i = 101, 110, 1 do
  print(i)
  end end)

coroutine.resume(co2)
coroutine.resume(co)
