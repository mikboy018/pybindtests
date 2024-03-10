#include "example.cuh"
#include "config.cuh"
#include <pybind11/embed.h>

namespace py = pybind11;



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
        d_m.ray_ops(a.threads,a.blocks,a.firstVal,a.secondVal,a.n,i,a.n_iter);
    }

    return 0;
}