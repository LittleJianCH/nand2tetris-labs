import os

def checkReDir(dir):
    list = []
    for filename in os.listdir(dir):
        if filename.endswith(".cmp"):
            name = filename.split(".")[0]
            if not os.path.isfile(dir + "/" + name + ".out"):
                list.append(name)
        elif os.path.isdir(dir + "/" + filename):
            list += checkReDir(dir + "/" + filename)
    return list

dir = "./" + input("Enter the directory to check: ")
list = checkReDir(dir)

if not list:
    print("All test cases passed")
else:
    print("Not all test cases passed")
    print("The following test cases failed:")
    for i in list:
        print("- " + i)
