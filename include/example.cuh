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

struct Pet {
    Pet(const std::string &name) : name(name),age(0) {}
    void setName(const std::string &name_) { name = name_;}
    const std::string &getName() const {return name;}

    std::string name;
    int age;
};

struct args {
    uint32_t n_iter;
    uint32_t n;
    uint32_t threads;
    uint32_t blocks;
    float firstVal;
    float secondVal;
    py::array_t<float> vec;
    LAUNCH_TYPE ltype;
};

int add(int i, int j);
int multiply(int i, int j);



#endif