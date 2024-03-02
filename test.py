import example
import numpy as np


if __name__ == '__main__':
    print(example.add(1,2))
    print(example.multiply(1,2))
    print(example.add())
    print(example.multiply())
    print(example.what)
    print(example.answer)
    p = example.Pet("fio")
    print(p.getName())
    p.setName("fido")
    print(p)
    p.age = 2
    print(p.age)
    print(p)
    
    n = 16
    threads = 32
    blocks = 1
    firstVal = 1.0
    secondVal = 2.0
    thirdVal = 1.25
    fourthVal = 1.5

    vec = np.ones(16,dtype=float)

    vals = example.sum_rays(threads,blocks,firstVal,secondVal,n,vec)

    print("vec")
    for i in range(0,n):
        print(vec[i])


    print("vals")
    for i in range(0,n):
        print(vals[i])
    
    
    vals2 = example.sum_rays(threads,blocks,thirdVal,fourthVal,n,vals) 
    print("vals2")
    for i in range(0,n):
        print(vals2[i])
    