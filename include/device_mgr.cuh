#ifndef __DEVICE_MGR_H
#define __DEVICE_MGR_H

#include <cuda.h>
#include <iostream>
#include <fstream>
#include <string>
#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>
#include <pybind11/iostream.h>
#include <chrono>
#include "common.cuh"
#include "example.cuh"
#include "kernel_launcher.cuh"

namespace py = pybind11;

class device_mgr {
    public:
    float * h_out; // Host-side data

    device_mgr();
    device_mgr(uint32_t _n, 
               LAUNCH_TYPE _lType, 
               uint32_t _threads, 
               uint32_t _blocks, 
               float _i, 
               float _j, 
               uint32_t _n_iter, 
               std::string _logfilename);
    ~device_mgr();
    void ray_ops();     
    py::array_t<float> getResults();

    private:
    float i = 0;
    float j = 0;
    uint32_t threads = 1;
    uint32_t blocks = 1;
    uint32_t n_iter = 1;
    uint32_t n = 0;
    size_t sz = 0;
    LAUNCH_TYPE lType;
    std::string logfilename;
    launcher * kl;
};

#endif