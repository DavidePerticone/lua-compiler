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

    





