
example: example.cu
	/usr/local/cuda/bin/nvcc -gencode arch=compute_80,code=sm_80 -O3 -shared -std=c++11 --compiler-options -fPIC $(shell python3 -m pybind11 --includes) example.cu -o example$(shell python3-config --extension-suffix)