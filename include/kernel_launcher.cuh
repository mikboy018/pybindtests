#ifndef __KERNEL_LAUNCHER_H
#define __KERNEL_LAUNCHER_H

#include "common.cuh"
#include "device_kernels.cuh"
#include <pybind11/pybind11.h>

namespace py = pybind11;

class launcher{
    std::ofstream logfile;
    std::chrono::_V2::system_clock::time_point start;
    std::chrono::_V2::system_clock::time_point stop;

    public:
    void launch_normal(py::array_t<float> vec, float * h_out, float * d_out, uint32_t threads, uint32_t blocks, float i, float j, uint32_t n, uint32_t iter, uint32_t n_iter); // Standard Kernel launch

    void launch_graph(); // Host Graph Launch

    void launch_device_graph(); // Device Graph Launch

};



#endif