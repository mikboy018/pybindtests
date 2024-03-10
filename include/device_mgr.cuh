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
    float * d_out; // Device-side data
    float * h_out; // Host-side data
    LAUNCH_TYPE l;

    device_mgr();
    device_mgr(const uint32_t n, LAUNCH_TYPE l_);
    ~device_mgr();
    void ray_ops(uint32_t threads, uint32_t blocks, float i, float j, uint32_t n, uint32_t iter, uint32_t n_iter);     
    void setVec(py::array_t<float> vec_);
    py::array_t<float> getVec();
    py::array_t<float> vec;
    size_t sz; // size of data
    launcher kl;
};

#endif