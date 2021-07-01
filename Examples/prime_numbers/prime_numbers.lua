
require "Math.lua"



function printPrime(n)

    
    local count=1
    

    repeat
        if Math.isPrime(count)==1 then
            print(count)
        end

        count=count+1

    until(count < n)
    return n

end


 printPrime(180)