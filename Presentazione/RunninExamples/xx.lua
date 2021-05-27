--Create list head
list = nil

--Put a new element at the beginning
list = {next = list, value = 5}

print(list["value"])
