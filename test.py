import lib.example as example
import numpy as np
import sys

def printvals(vec,iter):
    print("iter: ",iter)
    for i in range(0,len(vec)):
        print(vec[i])

def loop(n_iter,n,threads,blocks,first,sec,devdata,type):
    
    for i in range(0,n_iter):
        devdata.sum_rays(threads,blocks,first,sec,n,i,n_iter)
        #printvals(devdata.getVec(),i)

def load_args(argv)->dict:
    args = {}
    args["n"] = 1500
    args["n_iter"] = 20
    args["threads"] = 256
    args["blocks"] = 8
    args["firstVal"] = 1.0
    args["secondVal"] = 2.0

    for a in range(1,len(argv)):
        if a in ["n","n_iter","threads","blocks"]:
            args[a] = int(args[a+1])
            a += 1
        elif a in  ["firstVal","secondVal"]:
            args[a] = float(args[a+1])
    return args

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
    
    args = load_args(sys.argv)
    vec = np.ones(args["n"])
    devdata = example.device_mgr(args["n"],example.DEFAULT)
    devdata.setVec(vec)

    loop(args["n_iter"],args["n"],args["threads"],args["blocks"],args["firstVal"],args["secondVal"],devdata,devdata)
    