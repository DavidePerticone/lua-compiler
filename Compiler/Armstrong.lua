
require "Math.lua"


function check_armstrong(n) 
    
    local digits = 0
    local sum=0
    local t = n
    local result=0
  
    while t ~= 0 do

      digits=digits+1
      t = Math.floor(t/10)
    end
  
    t = n
  
    while t ~= 0 do

      remainder = Math.remainder(t, 10)
      sum = sum + Math.pow(remainder, digits)
      t = Math.floor(t/10)
    end

    if n == sum then
     result =  1
    else
      result = 0
    end

    return result
end   

   
    print("The Armstrong numbers in between 1 to 500 are : \n")

    for i = 0, 10000, 1
    do
        if(check_armstrong(i) == 1) then
         print(i)
        end
    end

    