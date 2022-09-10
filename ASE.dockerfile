FROM quay.io/centos/centos:stream8

RUN dnf install -y dnf-plugins-core && \
    dnf config-manager --set-enabled powertools && \
    dnf install -y epel-release && \
    dnf config-manager --enable epel 

# Dev/Build requirements
RUN dnf install -y python3 python3-pip python3-devel python3-pybind11 cmake make libuuid-devel json-c-devel gcc clang gcc-c++ hwloc-devel tbb-devel rpm-build rpmdevtools git
RUN dnf install -y libedit-devel
RUN dnf install -y libudev-devel
RUN dnf install -y libcap-devel

RUN python3 -m pip install --user \
        jsonschema \
        virtualenv \
        pudb \
        pyyaml

RUN pip3 uninstall -y setuptools
RUN pip3 install Pybind11==2.10.0
RUN pip3 install setuptools==59.6.0 --prefix=/usr

COPY artifacts/opae-sdk /opae-sdk

# Install OPAE and headers
RUN dnf install -y /opae-sdk/rpm_packages/opae*.rpm && \
    cmake3 -P /opae-sdk/rpm_packages/cmake_install.cmake

# OPAE Simulator
ARG OPAE_TAG=2.0.10-2
RUN git clone https://github.com/OPAE/opae-sim.git /opae-sim && \
    cd /opae-sim && \
    git checkout ${OPAE_TAG} && \
    mkdir -p /opae-sim/build && \
    cd /opae-sim/build && \
    cmake3 \
    -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=/usr /opae-sim && \
    make && \
    make install && \
    rm -rf /opae-sim && \
    rm -rf /opae-sdk

WORKDIR /src