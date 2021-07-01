
require "Math.lua"
require "stack.lua"



print(" This is an example of using to external files: Math.lua and stack.lua\n")
print("\n")
print(" 2 elevated to the fourth: ")

val = Math.pow(2, 4)



print(val)
print("\n")

print(rem)


stack.pushStack(Math.ceilingSqrt(63))
stack.pushStack(Math.pow(2, 4))
stack.pushStack(Math.pow(2.5, 8))
stack.pushStack(Math.ceilingSqrt(63.5))

stack.printStack()
print("\n")


a = 0
l= stack.popStack()
print(string.format(" Popped value %.0f\n", l))

stack.printStack()
print("\n")

