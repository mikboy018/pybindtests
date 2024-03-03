#include "example.cuh"

int add(int i, int j){
    return i+j;
}
int multiply(int i, int j){
    return i*j;
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

    py::class_<device_mgr>(m,"device_mgr")
        .def(py::init<const uint32_t &>())
        .def("sum_rays",&device_mgr::sum_rays)
        .def("getVec",&device_mgr::getVec)
        .def("setVec",&device_mgr::setVec);
    
}

device_mgr::device_mgr(){printf("device mgr!\n");}

device_mgr::device_mgr(const uint32_t n){
    printf("init setup\n");
    this->sz = sizeof(float)*n;
    printf("size (n): (%u):%lu\n",n,sz);
    gpuErrchk(cudaMalloc((void**)&this->d_out,this->sz));
    gpuErrchk(cudaMemset(this->d_out,0,this->sz));
    gpuErrchk(cudaDeviceSynchronize());
    gpuErrchk(cudaPeekAtLastError());
    printf("device mgr setup\n");
}

device_mgr::~device_mgr(){
    gpuErrchk(cudaFree(this->d_out));
}

void device_mgr::sum_rays(uint32_t threads, uint32_t blocks, float i, float j, uint32_t n, uint32_t iter, uint32_t n_iter){
    if(iter == 0){
        this->start = std::chrono::high_resolution_clock::now();
    }
    
    py::buffer_info host_data = vec.request();
    //h_out = (float*)malloc(sz);
    h_out = reinterpret_cast<float*>(host_data.ptr);
    //gpuErrchk(cudaMemcpy(d_out,h_out,sz,cudaMemcpyHostToDevice));
    //gpuErrchk(cudaDeviceSynchronize());
    //gpuErrchk(cudaPeekAtLastError());
    cuda_add_ray<<<threads,blocks>>>(d_out,i,j,n);
    gpuErrchk(cudaDeviceSynchronize());
    gpuErrchk(cudaPeekAtLastError());
    //gpuErrchk(cudaMemcpy(h_out,d_out,sz,cudaMemcpyDeviceToHost));
    //gpuErrchk(cudaDeviceSynchronize());
    //gpuErrchk(cudaPeekAtLastError());

    
    if(iter == n_iter-1){
        this->stop = std::chrono::high_resolution_clock::now();
        auto delta = std::chrono::duration_cast<std::chrono::microseconds>(stop-start).count();
        
        this->logfile.open("test.log");
        this->logfile<<"runtime (usec): "<<delta<<std::endl;
        this->logfile<<"avg (usec): "<<delta/n_iter<<std::endl;
        this->logfile.close();    
    }        
}

void device_mgr::setVec(py::array_t<float> vec_){
    this->vec = vec_;
}

py::array_t<float> device_mgr::getVec(){
    return this->vec;
}

__global__ void cuda_add_ray(float * d_out,float i, float j, uint32_t n){
    uint32_t global_thread = threadIdx.x + blockIdx.x * blockDim.x;
    uint32_t stride = blockDim.x * gridDim.x;

    for(uint32_t x = global_thread; x < n; x += stride){
        d_out[x] += i + j + x;
    }
}