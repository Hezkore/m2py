import monkey2
print("First extended function: ", monkey2.first())
print("First extended function: ", monkey2.second())

def multiply(a,b):
    print("Will compute", a, "times", b)
    c = 0
    for i in range(0, a):
        c = c + b
    return c
