import os

dir = input("Enter the directory to check: ")
list = []

for filename in os.listdir("./" + dir + "/"):
    if filename.endswith(".hdl"):
        name = filename.split(".")[0]
        if os.path.isfile(dir + "/" + name + ".cmp") and (not os.path.isfile(dir + "/" + name + ".out")):
            list.append(name)

if list == []:
    print("All test cases passed")
else:
    print("Not all test cases passed")
    print("The following test cases failed:")
    for i in list:
        print("- " + i)
