--[[

    Math library 1.0


--]]

--Pow
function pow(x, y) 

    local c=x
    local i=0
    
    for i=0, i<y-1, 1 do
    
    c=c*x
    
    end

    return c
end


--ceiling square root

function ceilingSqrt(x)
    
   if( x == 0 or x == 1)then
    return x
   end

   local i, result = 1, 1

   while( result < x ) do
    
    i=i+1
    result=i*i
   end


   return i
end


function floor(n)
    local i = 0
    for i=0, i<=n, 1 do
        i=i
    end

    return i-1

end

function remainder(dividend, divisor)

    local tmp = 0

    while ( tmp <= dividend ) do

        tmp = tmp + divisor

    end

   local  remainder = dividend - (tmp - divisor)

    return remainder
end
    

function isPrime(num)
    if num <= 0 then
          print("Number must be a positive integer greater than zero")
          return -1

    end

      if num == 1 then return 1 end
      
      local x = 0

      for x = num-1, x>2, -1 do
          if (((Math.remainder(num, x)) == 0) and x > 1) then
              return 0
          end
      end
  
      return 1
end





