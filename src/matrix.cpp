#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>

namespace py = pybind11;

py::array_t<double> calc_matrix(py::array_t<double> data) {
    if (data.ndim() == 1) {
        auto res = py::array_t<double>(1);
        auto res_proxy = res.mutable_unchecked<1>();
        auto data_proxy = data.unchecked<1>();
        res_proxy(0) = data_proxy(0);
        return res;
    } else if (data.ndim() == 2) {
        auto res = py::array_t<double>(data.shape(0));
        auto res_proxy = res.mutable_unchecked<1>();
        auto data_proxy = data.unchecked<2>();
        for (int i = 0; i < data.shape(0); i++) {
            res_proxy(i) = data_proxy(i, 0);
        }
        return res;
    }

    throw;
}

PYBIND11_MODULE(matrix, m) {
    m.def("calc_matrix", &calc_matrix);
}
