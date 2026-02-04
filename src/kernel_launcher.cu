#include "kernel_launcher.cuh"

launcher::launcher(){};

launcher::launcher(uint32_t _n, 
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
    graphBuilt = false;
    launcherGraphBuilt = false;
    n = _n;
    sz = sizeof(d_out[0])*n;
    gpuErrchk(cudaMalloc(&d_out,sz));
    gpuErrchk(cudaMemset(d_out,0,sz));
    gpuErrchk(cudaDeviceSynchronize());

    if(lType == LAUNCH_TYPE::GRAPH){
        build_graph();
    }
}

launcher::~launcher(){
    gpuErrchk(cudaDeviceReset());
}

void launcher::loop()
{
    for(int iter = 0; iter < n_iter; ++iter){
        cuda_add_ray<<<threads,blocks>>>(d_out,i,j,n);
        cuda_mult_ray<<<threads,blocks>>>(d_out,j,n);
        cuda_sin_ray<<<threads,blocks>>>(d_out,n);
        gpuErrchk(cudaPeekAtLastError());
    }
}

void launcher::launch_standard()
{
    printf("Normal Launching");
    auto start = std::chrono::high_resolution_clock::now();
        
    loop();
    gpuErrchk(cudaDeviceSynchronize());

    auto stop = std::chrono::high_resolution_clock::now();
    auto delta = std::chrono::duration_cast<std::chrono::microseconds>(stop-start).count();
    
    this->logfile.open(logfilename.c_str());
    this->logfile<<"runtime (usec): "<<delta<<std::endl;
    this->logfile<<"avg (usec): "<<delta/n_iter<<std::endl;
    this->logfile.close();
    printf("\nperformance logging complete\n");    
}

void launcher::launch_graph()
{
    cudaStream_t s;
    gpuErrchk(cudaStreamCreate(&s));

    printf("Host-launched graph");
    auto start = std::chrono::high_resolution_clock::now();
        
    // Launch Graph
    cudaGraphLaunch(graphExec,s);
    gpuErrchk(cudaStreamSynchronize(s));

    auto stop = std::chrono::high_resolution_clock::now();
    auto delta = std::chrono::duration_cast<std::chrono::microseconds>(stop-start).count();
    this->logfile.open(logfilename.c_str());
    this->logfile<<"runtime (usec): "<<delta<<std::endl;
    this->logfile<<"avg (usec): "<<delta/n_iter<<std::endl;
    this->logfile.close();
    printf("\nperformance logging complete\n");  

    gpuErrchk(cudaStreamDestroy(s));
}

void launcher::build_graph()
{
    cudaStream_t s;
    gpuErrchk(cudaStreamCreateWithFlags(&s,cudaStreamNonBlocking));
    gpuErrchk(cudaStreamBeginCapture(s,cudaStreamCaptureModeGlobal));
    loop();
    gpuErrchk(cudaStreamEndCapture(s,&graph));
    gpuErrchk(cudaGraphInstantiate(&graphExec,graph,NULL,NULL,0));
    gpuErrchk(cudaGraphUpload(graphExec,s));
    graphBuilt = true;
    gpuErrchk(cudaStreamDestroy(s));
}

float * launcher::transfer_result()
{
    float * h_out = (float*)malloc(sz);
    gpuErrchk(cudaMemcpy(h_out,d_out,sz,cudaMemcpyDeviceToHost));
    gpuErrchk(cudaDeviceSynchronize());
    return h_out;
}