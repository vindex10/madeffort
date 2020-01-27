#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>

#define STR(x) #x
#define EXPAND(x) STR(x)
#define CONCAT(a, b) a##b
#define TOFORTNAME(x) CONCAT(x, _)


#define FFNAME TOFORTNAME(FNAME)
#define PYFNAME EXPAND(FNAME)

extern "C" void FFNAME(const double* arr, double *res);

namespace py = pybind11;

py::array_t<double> FNAME(py::array_t<double, py::array::c_style | py::array::forcecast> data) {
    size_t dim = data.ndim();
    size_t size_head = data.shape(0);
    size_t size_rest = data.size()/size_head;

    if (dim > 3)
        throw;

    const double *pass = (const double*) data.data();

    py::array_t<double, 1> res(size_head);
    double * res_ptr = (double *) res.mutable_data();

    size_t i = 0;
    do {
        FFNAME(pass, &(*res_ptr));
        pass += size_rest;
        res_ptr += 1;
        i += 1;
    } while(i < size_head);

    return res;
}

PYBIND11_MODULE(MNAME, m) {
    m.def(PYFNAME, &FNAME);
}
