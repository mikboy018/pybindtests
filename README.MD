# PYBIND11 C++/CUDA/Python testing

Requires pybind11 & CUDA:
```
python3 -m pip install pybind11
```

```
make clean; make COMPUTE_CAPABILITY=XY -j; make test
```
Where Compute Capability depends on GPU. Pascal - 60 or 61; Turing - 70 or 75; Ampere - 80 or 86; Ada - 90

This will generate log files for python & cuda source results.

Coming soon: Documentation/Jupyter Notebooks for more interactive examples

Uses [nlohmann/json](https://github.com/nlohmann/json) for ingesting JSON-formatted arguments. MIT License.