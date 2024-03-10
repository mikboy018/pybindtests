
NVCC ?= /usr/local/cuda/bin/nvcc
NVCC_SHR_OUT = $(shell python3-config --extension-suffix)
NVCC_SHR_OPTS = -gencode arch=compute_80,code=sm_80 -shared -O3 -std=c++11 --compiler-options -fPIC $(shell python3 -m pybind11 --includes) 
NVCC_OPTS = -gencode arch=compute_80,code=sm_80 -O3 -std=c++11 --compiler-options -fPIC $(shell python3 -m pybind11 --includes)
NVCC_LINK_OPTS = -gencode arch=compute_80,code=sm_80 -O3 -std=c++11 --compiler-options -fPIC $(shell python3 -m pybind11 --includes)
NVCC_INC = -Iinclude/

bin/test: bin/test.o lib/example.so
	$(NVCC) $(NVCC_LINK_OPTS) $(NVCC_INC) --library-path=lib -Llib/example -lpython3.10 -o bin/test bin/test.o lib/example.so 

lib/example.so: bin/example.o bin/device_mgr.o bin/device_kernels.o bin/kernel_launcher.o
	$(NVCC) $(NVCC_SHR_OPTS) $(NVCC_INC) -o lib/example.so bin/example.o bin/device_mgr.o bin/device_kernels.o bin/kernel_launcher.o

bin/test.o: test.cu
	$(NVCC) $(NVCC_OPTS) $(NVCC_INC) -lpython3.10 -c test.cu -o $@

bin/example.o: src/example.cu
	$(NVCC) $(NVCC_OPTS) $(NVCC_INC) -lpython3.10 -c src/example.cu -o $@

bin/device_mgr.o: src/device_mgr.cu
	$(NVCC) $(NVCC_OPTS) $(NVCC_INC) -lpython3.10 -c src/device_mgr.cu -o $@

bin/device_kernels.o: src/device_kernels.cu
	$(NVCC) $(NVCC_OPTS) $(NVCC_INC) -c src/device_kernels.cu -o $@

bin/kernel_launcher.o: src/kernel_launcher.cu
	$(NVCC) $(NVCC_OPTS) $(NVCC_INC) -c src/kernel_launcher.cu -o $@

clean:
	rm bin/*o lib/*o bin/test.o