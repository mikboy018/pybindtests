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

namespace py = pybind11;

__global__ void cuda_add_ray(float * d_out, float i, float j, uint32_t n);

class device_mgr {
    public:
    float * d_out; // Device-side data
    float * h_out; // Host-side data
    std::ofstream logfile;
    std::chrono::_V2::system_clock::time_point start;
    std::chrono::_V2::system_clock::time_point stop;

    device_mgr();
    device_mgr(const uint32_t n);
    ~device_mgr();
    void sum_rays(uint32_t threads, uint32_t blocks, float i, float j, uint32_t n, uint32_t iter, uint32_t n_iter);     
    void setVec(py::array_t<float> vec_);
    py::array_t<float> getVec();
    py::array_t<float> vec;
    size_t sz; // size of data
};

#endif