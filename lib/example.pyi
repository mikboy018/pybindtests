"""
Stubfile lib.example, Demonstrating CUDA (optional Graphs) with Pybind11 + Makefiles
"""
from enum import Enum

class LAUNCH_TYPE(Enum):
    STANDARD = ...
    GRAPH = ...

class device_mgr:
    """
    device_mgr, the class handling the interface between Python and the C++/CUDA Launcher
    """

    def __init__(self,n: int, launchType: LAUNCH_TYPE, threads: int, blocks: int, firstVal: float, secondVal: float, n_iter: int, logfile: str)->None:
        """
        Docstring for __init__
        
        :param self: device_mgr
        :param n: Array size
        :type n: int
        :param launchType: Type of launch (STANDARD or GRAPH)
        :type launchType: LAUNCH_TYPE
        :param threads: Number of threads to use
        :type threads: int
        :param blocks: Number of blocks to use
        :type blocks: int
        :param firstVal: First value to use for math ops
        :type firstVal: float
        :param secondVal: Second value to use for math ops
        :type secondVal: float
        :param n_iter: Number of iterations to execute
        :type n_iter: int
        :param logfile: Logfile to save that captures performance info
        :type logfile: str
        """
        ...
        
    def ray_ops()->None:
        """
        Launch the kernels (using graphs if specified)
        """
        ...

    def getResults()->None:
        """
        Retrieve results from C++/CUDA side
        
        :return: Results of all the kernel calls after synchronization
        :rtype: list[float]
        """
        ...
        