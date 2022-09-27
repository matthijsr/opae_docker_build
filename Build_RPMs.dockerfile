FROM centos:7.6.1810

RUN yum install -y https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
RUN rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
RUN yum --enablerepo=elrepo-kernel install -y kernel-ml-headers

RUN yum install -y \
        python-devel \
        python3 \
        python3-pip \
        python3-devel \
        python3-pybind11 \
        make \
        libuuid-devel \
        json-c-devel \
        gcc \
        clang \
        gcc-c++ \
        hwloc-devel \
        tbb-devel \
        rpm-build \
        rpmdevtools \
        git \
        libedit-devel \
        epel-release

RUN yum install -y \
        libudev-devel \
        libcap-devel \
        cmake3 \
        openssl11-devel

RUN python3 -m pip install setuptools --upgrade
RUN python3 -m pip install wheel
RUN python3 -m pip install python-pkcs11 pyyaml jsonschema

ARG OPAE_TAG=2.0.11-1
COPY artifacts/opae-sdk /opae-sdk
RUN mkdir -p /opae-sdk/${OPAE_TAG} && \
    cd /opae-sdk/${OPAE_TAG} && \
    cmake3 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_GENERATOR=RPM \
    -DOPAE_BUILD_FPGABIST=ON \
    -DOPAE_BUILD_PYTHON_DIST=ON \
	-DCMAKE_INSTALL_PREFIX=/usr /opae-sdk && \
    cmake3 --build /opae-sdk/${OPAE_TAG} -- package_rpm -j $(nproc)
WORKDIR /opae-sdk
