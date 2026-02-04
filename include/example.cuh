#ifndef __EXAMPLE_H
#define __EXAMPLE_H

#include <cuda.h>
#include <iostream>
#include <fstream>
#include <string>
#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>
#include <pybind11/iostream.h>
#include <chrono>
#include "common.cuh"
#include "device_mgr.cuh"

namespace py = pybind11;

struct args {
    uint32_t n_iter;
    uint32_t n;
    uint32_t threads;
    uint32_t blocks;
    float firstVal;
    float secondVal;
    py::array_t<float> vec;
    LAUNCH_TYPE ltype;
    std::string logfile;
    void print(){
        printf("n_iter: %u, n: %u, threads: %u, blocks: %u, firstVal: %8.4f, secondVal: %8.4f\n",n_iter,n,threads,blocks,firstVal,secondVal);
    }
};

#endif