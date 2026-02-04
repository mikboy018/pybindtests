# PYBIND11 C++/CUDA/Python testing

Requires pybind11 & CUDA:
```
python3 -m pip install pybind11
```

```
make clean; make COMPUTE_CAPABILITY=XY -j; make test
```

This will generate log files for python & cuda source results.

Coming soon: Documentation/Jupyter Notebooks for more interactive examples