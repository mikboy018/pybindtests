#include "device_mgr.cuh"
#include "kernel_launcher.cuh"

device_mgr::device_mgr(void){
    printf("device mgr is alive!\n");
}

device_mgr::device_mgr(const uint32_t n,LAUNCH_TYPE l_){
    printf("init setup\n");
    this->sz = sizeof(float)*n;
    printf("size (n): (%u):%lu\n",n,sz);
    gpuErrchk(cudaMalloc((void**)&this->d_out,this->sz));
    gpuErrchk(cudaMemset(this->d_out,0,this->sz));
    gpuErrchk(cudaDeviceSynchronize());
    gpuErrchk(cudaPeekAtLastError());
    printf("device mgr setup\n");
    this->l = l_;
    if(this->l == LAUNCH_TYPE::DEFAULT){
        printf("Normal Graph Launches\n");
    } else if(this->l == LAUNCH_TYPE::H_GRAPH){
        printf("Host Launched Graphs\n");
    } else if(this->l == LAUNCH_TYPE::D_GRAPH){
        printf("Device Launched Graphs\n");
    } else {
        std::cerr<<"[ERROR]: Must specify graph\n"<<std::endl;
        exit(1);
    }
}

device_mgr::~device_mgr(){
    gpuErrchk(cudaFree(this->d_out));
}

void device_mgr::ray_ops(uint32_t threads, uint32_t blocks, float i, float j, uint32_t n, uint32_t iter, uint32_t n_iter){
    switch(this->l){
        case DEFAULT:
            kl.launch_normal(this->vec, this->h_out, this->d_out, threads, blocks, i, j, n, iter, n_iter);
            break;
        case H_GRAPH:
            printf("TODO - Host Launched Graphs\n");
            kl.launch_graph();
            break;
        case D_GRAPH:
            printf("TODO - Device Launched Graphs\n");
            kl.launch_device_graph();
            break;
    }        
}

void device_mgr::setVec(py::array_t<float> vec_){
    this->vec = vec_;
}

py::array_t<float> device_mgr::getVec(){
    return this->vec;
}

