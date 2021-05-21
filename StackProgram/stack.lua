
stack={0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
size=10
full=0





function signalTOS(pos, sim)

    local i=0
    size=9
    print("\n")
    while(i<pos) do
        local j=0

        
        i=i+1
        if(i~=pos-1) then
            print("   ")
            
        else
            print(" ")
            if sim==1 then
            print("|")
            else
            print("^")
            end
            

        end

    end

 
    return 1
end

function printStack()
    print("\n ")
    local i=0



    

    print("---------------------")
    print("\n ")
    repeat
        print(string.format("%.0f ", stack[i]))
        i=i+1
    until(i<full)
    print("\n ")
    print("---------------------")
    signalTOS(full, 0)
    signalTOS(full, 1)
    print("\n ")
    return 0
end

function pushStack(toPush)

    if(full==size) then
        print("Stack is full")
        return -1
    end

    stack[full]=toPush
    full=full+1

    return 1
end

function popStack()

    if(full==0)then
        print("Stack is empty")
        return -1
    end
    full=full-1
    local tmp = stack[full]
    
    return tmp

end



pushStack(1)
pushStack(2)
pushStack(3)
pushStack(4)



printStack()

a=popStack()
print(string.format("POPPED VALUE: %.0f\n", a))

print(2^a)
printStack()