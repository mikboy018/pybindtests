#include "example.cuh"

PYBIND11_MODULE(example, m) {
    m.doc() = "pybind11 example plugin w/CUDA Graphs"; // optional module docstring

    // Objects
    py::class_<device_mgr>(m,"device_mgr")
        .def(py::init<uint32_t&,LAUNCH_TYPE&, uint32_t&, uint32_t&, float&, float&, uint32_t&, std::string&>())
        .def("ray_ops",&device_mgr::ray_ops)
        .def("getResults",&device_mgr::getResults);

    py::enum_<LAUNCH_TYPE>(m,"LAUNCH_TYPE")
        .value("STANDARD",LAUNCH_TYPE::STANDARD)
        .value("GRAPH",LAUNCH_TYPE::GRAPH)
        .export_values();
}