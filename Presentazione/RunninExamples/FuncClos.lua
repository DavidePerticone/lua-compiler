--[[

FuncClose.lua
Example for:
-Global and local variables
-Functions as first-class values
-Multiple results from function
-Function lexical scoping

--]]


-- A Closure is a function that can access local
-- variables of and enclosing function

function outerFunc()
	local i = 0
	return function()
		i=i+1
		return i
	end, function(a)
		i=i+a
		return i
	end

end


counter, counterAddN = outerFunc() --return a new counter
counter2 = outerFunc() 			   --return a new counter

print("First counter, add 1", counter())  --return the increased value of the local variable of the outer function
print("First counter, addN", counterAddN(3)) --return the increased value by N of the local variable of the outer function

print("Second counter", counter2()) --This is a new counter, so it starts from 0


print(i) --Why does it print nil? Local vs Global









