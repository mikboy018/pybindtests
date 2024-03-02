import example
import numpy as np

def printvals(vec,iter):
    print("iter: ",iter)
    for i in range(0,len(vec)):
        print(vec[i])

def loop(n_iter,n,threads,blocks,first,sec,devdata):
    
    for i in range(0,n_iter):
        devdata.sum_rays(threads,blocks,first,sec,n,i)
        printvals(devdata.getVec(),i)


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
    
    n_iter = 1900
    n = 1500
    threads = 1024
    blocks = 32
    firstVal = 1.0
    secondVal = 2.0
    vec = np.ones(n)
    devdata = example.device_mgr(n)
    devdata.setVec(vec)

    loop(n_iter,n,threads,blocks,firstVal,secondVal,devdata)
    