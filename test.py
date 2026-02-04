import lib.example as example
import numpy as np
import sys

def load_args(argv)->dict:
    args = {}
    args["n"] = 1500
    args["n_iter"] = 20
    args["threads"] = 256
    args["blocks"] = 8
    args["firstVal"] = 1.0
    args["secondVal"] = 1.0
    args["launchType"] = example.STANDARD
    args["logfile"] = 'py.log'

    for a in range(1,len(argv)):
        if argv[a] in ["n","n_iter","threads","blocks"]:
            args[a] = int(argv[a+1])
            a += 1
        elif argv[a] in  ["firstVal","secondVal"]:
            argv[a] = float(argv[a+1])
            a += 1
        elif argv[a] in ["launchType"]:
            val = argv[a+1]
            if val == "STANDARD":
                args["launchType"] = example.STANDARD
            elif val == "GRAPH":
                args["launchType"] = example.GRAPH
            a += 1
        elif argv[a] in ["logfile"]:
            val = argv[a+1]
            args['logfile'] = val
            a += 1
    return args

if __name__ == '__main__':

    args = load_args(sys.argv)
    devdata = example.device_mgr(args["n"],args["launchType"],args['threads'],args['blocks'],args['firstVal'],args['secondVal'],args['n_iter'],args['logfile'])
    devdata.ray_ops()
    h_out = devdata.getResults()
    print(args)
    print(h_out)
    