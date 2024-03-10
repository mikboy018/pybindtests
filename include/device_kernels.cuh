#ifndef __DEVICE_KERNELS_H
#define __DEVICE_KERNELS_H

#include <cuda.h>
#include "common.cuh"

__global__ void cuda_add_ray(float * d_out, float i, float j, uint32_t n);

#endif