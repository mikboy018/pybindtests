#include "example.cuh"
#include <pybind11/embed.h>

namespace py = pybind11;

int main(int argc, char * argv[]){
    printf("hi earth\n");
    py::scoped_interpreter guard{}; // Now we can call device mgr with python extensions
    
    printf("sum 1+2=%i\n",add(1,2));
    uint32_t n_iter = 20;
    uint32_t n = 1500;
    uint32_t threads = 256;
    uint32_t blocks = 8;
    float firstVal = 1.0f;
    float secondVal = 1.0f;
    
    device_mgr d_m(n);
    py::array_t<float> vec = py::array_t<float>(n*sizeof(float));
    d_m.vec = vec;



    cudaSetDevice(0);


    for(int i = 0; i < 40; ++i){
        d_m.sum_rays(threads,blocks,firstVal,secondVal,n,i,n_iter);
    }

    return 0;
}