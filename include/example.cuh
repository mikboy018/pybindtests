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

namespace py = pybind11;

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      std::ofstream logfile;
      logfile.open("err.log");
      logfile<<"GPUassert: "<< cudaGetErrorString(code)<< file<< line<< std::endl;
      logfile.close();
      if (abort) exit(code);
   }
}

struct Pet {
    Pet(const std::string &name) : name(name),age(0) {}
    void setName(const std::string &name_) { name = name_;}
    const std::string &getName() const {return name;}

    std::string name;
    int age;
};

int add(int i, int j);
int multiply(int i, int j);


__global__ void cuda_add_ray(float * d_out,float i, float j, uint32_t n);

class device_mgr {
   float * d_out; // Device-side data
   float * h_out; // Host-side data
   std::ofstream logfile;
   std::chrono::_V2::system_clock::time_point start;
   std::chrono::_V2::system_clock::time_point stop;
   public:
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