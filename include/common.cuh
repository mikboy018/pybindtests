#ifndef __COMMON_H
#define __COMMON_H

#include <cuda.h>
#include <iostream>
#include <fstream>
#include <string>
#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>
#include <pybind11/iostream.h>
#include <chrono>

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

enum LAUNCH_TYPE {
   STANDARD=0,
   GRAPH=1,
};

#endif