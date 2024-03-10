#include "device_kernels.cuh"

__global__ void cuda_add_ray(float * d_out,float i, float j, uint32_t n){
    uint32_t global_thread = threadIdx.x + blockIdx.x * blockDim.x;
    uint32_t stride = blockDim.x * gridDim.x;

    for(uint32_t x = global_thread; x < n; x += stride){
        d_out[x] += i + j + x;
    }
}

__global__ void cuda_mult_ray(float * d_out, float val, uint32_t n){
    uint32_t global_thread = threadIdx.x + blockIdx.x * blockDim.x;
    uint32_t stride = blockDim.x * gridDim.x;

    for(uint32_t x = global_thread; x < n; x += stride){
        d_out[x] *= val;
    }
}

__global__ void cuda_sin_ray(float * d_out, uint32_t n){
    uint32_t global_thread = threadIdx.x + blockIdx.x * blockDim.x;
    uint32_t stride = blockDim.x * gridDim.x;

    for(uint32_t x = global_thread; x < n; x += stride){
        d_out[x] = sin(d_out[x]);
    }
}