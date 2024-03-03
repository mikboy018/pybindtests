
NVCC ?= /usr/local/cuda/bin/nvcc
NVCC_SHR_OUT = $(shell python3-config --extension-suffix)
NVCC_SHR_OPTS = -gencode arch=compute_80,code=sm_80 -shared -O3 -std=c++11 --compiler-options -fPIC $(shell python3 -m pybind11 --includes) 
NVCC_OPTS = -gencode arch=compute_80,code=sm_80 -O3 -std=c++11 --compiler-options -fPIC $(shell python3 -m pybind11 --includes)
NVCC_INC = -Iinclude/

bin/test: test.cu lib/example.so
	$(NVCC) $(NVCC_OPTS) $(NVCC_INC) -Llib -lpython3.10 test.cu -o bin/test lib/example.so
	$(shell cp lib/example.so .)

lib/example.so: src/example.cu
	$(NVCC) $(NVCC_SHR_OPTS) $(NVCC_INC) src/example.cu -o $@

clean:
	rm bin/*o lib/*o