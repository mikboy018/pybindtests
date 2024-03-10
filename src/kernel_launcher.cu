#include "kernel_launcher.cuh"

void launcher::launch_normal(py::array_t<float> vec, float * h_out, float * d_out, uint32_t threads, uint32_t blocks, float i, float j, uint32_t n, uint32_t iter, uint32_t n_iter){
    printf("\rlaunch normal");fflush(stdout);
    if(iter == 0){
        this->start = std::chrono::high_resolution_clock::now();
    }
    
    py::buffer_info host_data = vec.request();
    //h_out = (float*)malloc(sz);
    //h_out = reinterpret_cast<float*>(host_data.ptr);
    //gpuErrchk(cudaMemcpy(d_out,h_out,sz,cudaMemcpyHostToDevice));
    //gpuErrchk(cudaDeviceSynchronize());
    //gpuErrchk(cudaPeekAtLastError());
    cuda_add_ray<<<threads,blocks>>>(d_out,i,j,n);
    cuda_mult_ray<<<threads,blocks>>>(d_out,j,n);
    cuda_sin_ray<<<threads,blocks>>>(d_out,n);
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
        printf("\nperformance logging complete\n");    
    }     

}

void launcher::launch_graph(){printf("launch graph\n");}

void launcher::launch_device_graph(){printf("launch device graph\n");}