#include <cuda.h>
#include <iostream>
#include <fstream>
#include <string.h>
#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>
#include <pybind11/iostream.h>

namespace py = pybind11;

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      std::ofstream logfile;
      logfile.open("test.log");
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

int add(int i, int j) {
    return i + j;
}

int multiply(int i, int j){
    return i * j;
}

__global__ void cuda_add_ray(float * d_out,float i, float j, uint32_t n){
    uint32_t global_thread = threadIdx.x + blockIdx.x * blockDim.x;
    uint32_t stride = blockDim.x * gridDim.x;

    for(uint32_t x = global_thread; x < n; x += stride){
        d_out[x] += i + j;
    }
}

py::array_t<float> sum_rays(uint32_t threads, uint32_t blocks, float i, float j, uint32_t n, py::array_t<float> vec){
    float* d_out,*h_out;
    py::buffer_info host_data = vec.request();
    size_t sz = n*sizeof(float);
    gpuErrchk(cudaMalloc((void**)&d_out,sz));
    //h_out = (float*)malloc(sz);
    h_out = reinterpret_cast<float*>(host_data.ptr);
    gpuErrchk(cudaMemcpy(d_out,h_out,sz,cudaMemcpyHostToDevice));
    gpuErrchk(cudaDeviceSynchronize());
    gpuErrchk(cudaPeekAtLastError());
    cuda_add_ray<<<threads,blocks>>>(d_out,i,j,n);
    gpuErrchk(cudaDeviceSynchronize());
    gpuErrchk(cudaPeekAtLastError());
    gpuErrchk(cudaMemcpy(h_out,d_out,sz,cudaMemcpyDeviceToHost));
    gpuErrchk(cudaDeviceSynchronize());
    gpuErrchk(cudaPeekAtLastError());

    return vec;
}


PYBIND11_MODULE(example, m) {
    m.doc() = "pybind11 example plugin"; // optional module docstring

    // Functions
    m.def("add", &add, "A function that adds two numbers",py::arg("i")=1,py::arg("j")=2);
    m.def("multiply", &multiply, "A function that multiplies two numbers",py::arg("i")=1,py::arg("j")=2);

    // Attributes
    m.attr("answer") = 42;
    py::object world = py::cast("world");
    m.attr("what") = world;

    // Objects
    py::class_<Pet>(m,"Pet")
        .def(py::init<const std::string &>())
        .def("setName",&Pet::setName)
        .def("getName",&Pet::getName)
        .def("__repr__",
            [](const Pet &a){
                return "Pet Named: " + a.name + ", Age: " + std::to_string(a.age) + "\n";
            })
        .def_readwrite("age",&Pet::age);

    // Arrays w/CUDA
    m.def("sum_rays",&sum_rays,"add two arrays (floats)");
    
}
