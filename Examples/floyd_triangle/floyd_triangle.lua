
a = 0
l= 15
print("Triangle\n")
for i=0, i<=l, 1 do

    for k=0, k<=i, 1 do
        print(string.format("%.0f ", a))
        a=a+1
    end
    a=0
    print("\n")

end

