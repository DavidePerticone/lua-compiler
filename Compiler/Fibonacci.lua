
    
 
    first_term, second_term = 0, 1
    count = 20
 
    print(" First 20 terms of Fibonacci series:\n")
   
    for  i = 0 , i < count , 1 do
    
       if ( i <= 1 ) then
          next_term = i
       else
       
          next_term = first_term + second_term
          first_term = second_term
          second_term = next_term
       end
       print("Next term:")
       print(next_term)
       print("\n")
    end
 
    
