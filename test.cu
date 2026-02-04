#include "example.cuh"
#include "config.cuh"
#include <pybind11/embed.h>

namespace py = pybind11;

int main(int argc, char * argv[]){
    py::scoped_interpreter guard{}; // Now we can call device mgr with python extensions

    args a = load_args(argc,argv);
       
    device_mgr d_m(a.n,a.ltype,a.threads,a.blocks,a.firstVal,a.secondVal,a.n_iter,a.logfile);

    d_m.ray_ops();

    for(uint32_t i = 0; i < a.n; ++i){
        printf("%u: %8.8f\t",i,d_m.h_out[i]);
    }
    printf("\n");
    return 0;
}