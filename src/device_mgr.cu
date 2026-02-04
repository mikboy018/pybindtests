#include "device_mgr.cuh"
#include "kernel_launcher.cuh"

device_mgr::device_mgr(void){}

device_mgr::device_mgr(uint32_t _n, 
                       LAUNCH_TYPE _lType, 
                       uint32_t _threads, 
                       uint32_t _blocks, 
                       float _i, 
                       float _j, 
                       uint32_t _n_iter, 
                       std::string _logfilename)
{
    lType = _lType;
    threads = _threads;
    blocks = _blocks;
    n_iter = _n_iter;
    logfilename = _logfilename;
    i = _i;
    j = _j;
    n = _n;
    sz = sizeof(float)*n;
    kl = new launcher(n,lType,threads,blocks,i,j,n_iter,logfilename);
}

device_mgr::~device_mgr(){}

void device_mgr::ray_ops(){
    switch(this->lType){
        case LAUNCH_TYPE::STANDARD:
            kl->launch_standard();
            break;
        case LAUNCH_TYPE::GRAPH:
            kl->launch_graph();
            break;
    }
    h_out = kl->transfer_result();     
}

py::array_t<float> device_mgr::getResults(){
    auto result = py::array_t<float>(n);
    auto buffer = result.mutable_unchecked<1>();
    for(uint32_t i = 0; i < n; ++i){
        buffer(i) = static_cast<float>(h_out[i]);
    }
    return result;
}

