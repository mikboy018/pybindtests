#include "example.cuh"
#include <pybind11/embed.h>

namespace py = pybind11;

args load_args(int argc, char * argv[]){
    args a;
    a.n_iter = 20;
    a.n = 1500;
    a.threads = 256;
    a.blocks = 8;
    a.firstVal = 1.0f;
    a.secondVal = 1.0f;
    for(uint32_t i = 0; i < argc; ++i){
        printf("%s\n",argv[i]);
        if(strcmp(argv[i],"n_iter")==0){
            a.n_iter = std::stoi(argv[i+1]);
            ++i;
        }else if(strcmp(argv[i],"n")==0){
            a.n = std::stoi(argv[i+1]);
            ++i;
        }else if(strcmp(argv[i],"threads")==0){
            a.threads = std::stoi(argv[i+1]);
            ++i;
        }else if(strcmp(argv[i],"blocks")==0){
            a.blocks = std::stoi(argv[i+1]);
            ++i;
        }else if(strcmp(argv[i],"firstVal")==0){
            a.firstVal = std::stof(argv[i+1]);
            ++i;
        }else if(strcmp(argv[i],"secondVal")==0){
            a.secondVal = std::stof(argv[i+1]);
            ++i;
        }else if(strcmp(argv[i],"launchType")==0){
            ++i;
            if(strcmp(argv[i],"DEFAULT")==0){
                a.ltype = DEFAULT;
            }else if(strcmp(argv[i],"H_GRAPH")==0){
                a.ltype = H_GRAPH;
            }else if(strcmp(argv[i],"D_GRAPH")==0){
                a.ltype = D_GRAPH;
            }
        }
    }

    return a;
}

int main(int argc, char * argv[]){
    printf("hi earth\n");
    py::scoped_interpreter guard{}; // Now we can call device mgr with python extensions

    args a = load_args(argc,argv);
    
    
    printf("sum 1+2=%i\n",add(1,2));
    
    device_mgr d_m(a.n,a.ltype);
    a.vec = py::array_t<float>(d_m.sz);
    d_m.vec = a.vec;

    

    cudaSetDevice(0);

    for(int i = 0; i < a.n_iter; ++i){
        d_m.sum_rays(a.threads,a.blocks,a.firstVal,a.secondVal,a.n,i,a.n_iter);
    }

    return 0;
}