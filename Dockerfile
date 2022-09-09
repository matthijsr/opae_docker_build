FROM centos:7.7.1908

RUN yum install -y epel-release

# Dev/Build requirements
RUN yum install -y \
        autoconf \
        automake \
        bison \
        boost \
        boost-devel \
        cmake3 \
        doxygen \
        dwarves \
        elfutils-libelf-devel \
        flex \
        gcc \
        gcc-c++ \
        git \
        hwloc-devel \
        json-c-devel \
        libarchive \
        libedit \
        libedit-devel \
        libpcap \
        libpng12 \
        libuuid \
        libuuid-devel \
        libxml2 \
        libxml2-devel \
        make \
        ncurses \
        spdlog \
        cli11-devel \
        python3-yaml \
        python3-pybind11 \
        ncurses-devel \
        ncurses-libs \
        openssl-devel \
        python3-pip \
        python3-devel \
        python3-jsonschema \
        rsync \
        tbb-devel \
        libudev-devel

RUN python3 -m pip install --user \
        jsonschema \
        virtualenv \
        pudb \
        pyyaml

RUN pip3 install Pybind11==2.10.0
RUN pip3 install setuptools==59.6.0 --prefix=/usr

# Open Programmable Acceleration Engine
ARG OPAE_VERSION=2.0.9-4
RUN git clone -b ${OPAE_VERSION} --single-branch https://github.com/OPAE/opae-sdk.git /opae-sdk

RUN mkdir -p /opae-sdk/build && \
    cd /opae-sdk/build && \
    cmake3 /opae-sdk \
    -DCPACK_GENERATOR=RPM \
    -DOPAE_BUILD_FPGABIST=ON \
    -DOPAE_BUILD_PYTHON_DIST=ON \
    -DCMAKE_BUILD_PREFIX=/usr && \
    make -j `nproc`

RUN make -j `nproc` package_rpm

RUN cd /opae-sdk/build && \
    dnf localinstall -y opae*.rpm

WORKDIR /src
