
require "Math.lua"
require "stack.lua"
function coroutine(a) 

    local a=5
    print(a)
    print("\n")


    return 1

end



a=5


coroutine(5)






stack.pushStack(Math.ceilingSqrt(63))
stack.pushStack(Math.pow(2, 4))
stack.pushStack(Math.pow(2.5, 8))
stack.pushStack(Math.ceilingSqrt(63.5))

stack.printStack()
print("\n")

--TRIANGLE WITH L POPPED FROM STACK
a = 0
l= stack.popStack()
print("Triangle\n")
for i=0, i<=l, 1 do

    for k=0, k<=i, 1 do
        print(string.format("%.0f ", a))
        a=a+1
    end
    a=0
    print("\n")

end

--END TRIANGLE

--START BUBBLE SORT
v = {3,1,2,5,3,6,8,2,1,9}
size = 10
swapped = 1 



print("\n")
print("Unsorted\n")
a=0
while(a~=size)do
    print(string.format("%.0f ", v[a]))
    a=a+1
end
print("\n")
print("\n")
while swapped == 1 do
    swapped = 0

    for i=0, i<size, 1  do

        if(v[i-1]>v[i]) then
            temp = v[i]
            
            v[i] = v[i-1]
            v[i-1] = temp 
            
            swapped = 1 
            
            
        end
    end
    
end

print("Sorted\n")
a=0
while(a~=size)do
    print(string.format("%.0f ", v[a]))
    a=a+1
end
print("\n")

--END




