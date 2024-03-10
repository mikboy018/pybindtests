#ifndef __CONFIG_H
#define __CONFIG_H

#include "json.hpp"
#include "example.cuh"
#include <string.h>
#include <fstream>
#include <json.hpp>
using json = nlohmann::json;

// Loads json file, converts to config
args load_json_config(std::string filepath);

// Command-Line Args
args load_args(int argc, char * argv[]);

#endif