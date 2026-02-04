#ifndef __KERNEL_LAUNCHER_H
#define __KERNEL_LAUNCHER_H

#include "common.cuh"
#include "device_kernels.cuh"
#include <pybind11/pybind11.h>

namespace py = pybind11;

class launcher
{
    public:
    launcher();
    launcher(uint32_t _n, LAUNCH_TYPE _lType, uint32_t _threads, uint32_t _blocks, float _i, float _j, uint32_t _n_iter, std::string _logfile);
    ~launcher();

    /**
     * @brief Standard Kernel Launch
     */
    void launch_standard();

    /**
     * @brief Graph Launch
     */
    void launch_graph(); 

    /**
     * @brief Transfer results to host
     */
    float * transfer_result();

    private:
    float i = 0.0;
    float j = 0.0;
    uint32_t threads = 1;
    uint32_t blocks = 1;
    uint32_t n_iter = 0;
    float * d_out = nullptr;
    uint32_t n = 0;
    size_t sz = 0;
    LAUNCH_TYPE lType;
    std::string logfilename;
    std::ofstream logfile;
    cudaGraph_t graph;
    cudaGraphExec_t graphExec;
    bool graphBuilt = false;
    bool launcherGraphBuilt = false;

    /**
     * @brief Loop through all iterations
     */
    void loop();

    /**
     * @brief Build a graph
     */
    void build_graph(); 

};



#endif