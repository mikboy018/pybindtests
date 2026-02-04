#include "config.cuh"

args load_json_config(std::string filepath){
    std::ifstream f(filepath);
    json data = json::parse(f);

    args a; 
    a.n_iter = data.at("n_iter");
    a.n = data.at("n");
    a.threads = data.at("threads");
    a.blocks = data.at("blocks");
    a.firstVal = data.at("firstVal");
    a.secondVal = data.at("secondVal");
    std::string ltype = data.at("launchType");
    if(strcmp(ltype.c_str(),"STANDARD")==0){
        a.ltype = LAUNCH_TYPE::STANDARD;
    }else if(strcmp(ltype.c_str(),"GRAPH")==0){
        a.ltype = LAUNCH_TYPE::GRAPH;
    }
    a.logfile = data.at("logfile");

    return a;
}

args load_args(int argc, char * argv[]){
    args a;
    a.n_iter = 20;
    a.n = 1500;
    a.threads = 256;
    a.blocks = 8;
    a.firstVal = 1.0;
    a.secondVal = 1.0;
    a.ltype = LAUNCH_TYPE::STANDARD;
    a.logfile = "cu.log";

    bool json_config = false;

    // First check if a json is specified
    for(uint32_t i = 0; i < argc; ++i){
        if(strcmp(argv[i],"json")==0){
            json_config = true;
            a = load_json_config(argv[i+1]);
        }
    }

    if(!json_config){
        for(uint32_t i = 0; i < argc; ++i){
            printf("%s\n",argv[i]);
            if(strcmp(argv[i],"n_iter")==0){
                a.n_iter = std::stoi(argv[i+1]);
                ++i;
            }else if(strcmp(argv[i],"n")==0){
                a.n = std::stoi(argv[i+1]);
                ++i;
            }else if(strcmp(argv[i],"threads")==0){
                a.threads = std::stoi(argv[i+1]);
                ++i;
            }else if(strcmp(argv[i],"blocks")==0){
                a.blocks = std::stoi(argv[i+1]);
                ++i;
            }else if(strcmp(argv[i],"firstVal")==0){
                a.firstVal = std::stof(argv[i+1]);
                ++i;
            }else if(strcmp(argv[i],"secondVal")==0){
                a.secondVal = std::stof(argv[i+1]);
                ++i;
            }else if(strcmp(argv[i],"logfile")==0){
                ++i;
                a.logfile = argv[i];
            }else if(strcmp(argv[i],"launchType")==0){
                ++i;
                if(strcmp(argv[i],"STANDARD")==0){
                    a.ltype = STANDARD;
                }else if(strcmp(argv[i],"GRAPH")==0){
                    a.ltype = GRAPH;
                }
            }
        }
    }

    return a;
}