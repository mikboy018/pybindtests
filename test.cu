#include "pybind11/pybind11.h"
#include "example.cuh"

int main(int argc, char * argv[]){
    printf("hi earth\n");
    //device_mgr d_m;
    printf("sum 1+2=%i\n",add(1,2));


    return 0;
}