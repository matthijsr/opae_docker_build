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
RUN git clone -b ${OPAE_VERSION} --single-branch https://github.com/OPAE/opae-sdk.git /opae-sdk && \
    mkdir -p /opae-sdk/build && \
    cd /opae-sdk/build && \
    cmake3 \
    -DCMAKE_BUILD_TYPE=Release \
    -DOPAE_BUILD_LEGACY=ON \
    -DOPAE_LEGACY_TAG=2.0.9-4 \
    -DOPAE_ENABLE_MOCK=On \
    -DOPAE_BUILD_LIBOPAE_PY=On \
    -DOPAE_BUILD_LIBOPAEVFIO=Off \
    -DOPAE_BUILD_PLUGIN_VFIO=Off \
    -DOPAE_BUILD_EXTRA_TOOLS=On  \
	-DCMAKE_INSTALL_PREFIX=/usr /opae-sdk && \
    make -j && \
    make install && \
    rm -rf /opae-sdk

WORKDIR /src
