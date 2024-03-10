#include "example.cuh"

int add(int i, int j){
    return i+j;
}
int multiply(int i, int j){
    return i*j;
}

PYBIND11_MODULE(example, m) {
    m.doc() = "pybind11 example plugin"; // optional module docstring

    // Functions
    m.def("add", &add, "A function that adds two numbers",py::arg("i")=1,py::arg("j")=2);
    m.def("multiply", &multiply, "A function that multiplies two numbers",py::arg("i")=1,py::arg("j")=2);

    // Attributes
    m.attr("answer") = 42;
    py::object world = py::cast("world");
    m.attr("what") = world;

    // Objects
    py::class_<Pet>(m,"Pet")
        .def(py::init<const std::string &>())
        .def("setName",&Pet::setName)
        .def("getName",&Pet::getName)
        .def("__repr__",
            [](const Pet &a){
                return "Pet Named: " + a.name + ", Age: " + std::to_string(a.age) + "\n";
            })
        .def_readwrite("age",&Pet::age);

    py::class_<device_mgr>(m,"device_mgr")
        .def(py::init<const uint32_t &,LAUNCH_TYPE &>())
        .def("sum_rays",&device_mgr::sum_rays)
        .def("getVec",&device_mgr::getVec)
        .def("setVec",&device_mgr::setVec)
        .def_readwrite("l",&device_mgr::l);

    py::enum_<LAUNCH_TYPE>(m,"LAUNCH_TYPE")
        .value("DEFAULT",LAUNCH_TYPE::DEFAULT)
        .value("H_GRAPH",LAUNCH_TYPE::H_GRAPH)
        .value("D_GRAPH",LAUNCH_TYPE::D_GRAPH)
        .export_values();
    
}