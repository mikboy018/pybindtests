#ifndef __DEVICE_KERNELS_H
#define __DEVICE_KERNELS_H

#include <cuda.h>
#include "common.cuh"

__global__ void cuda_add_ray(float * d_out, float i, float j, uint32_t n);
__global__ void cuda_mult_ray(float * d_out, float val, uint32_t n);
__global__ void cuda_sin_ray(float * d_out, uint32_t n);

#endif