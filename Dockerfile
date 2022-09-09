FROM fedora:37

# # Kernel and DFL drivers
# RUN dnf install -y \
#         gcc \
#         gcc-c++ \
#         make \
#         kernel-headers \
#         kernel-devel \
#         elfutils-libelf-devel \
#         ncurses-devel \
#         openssl-devel \
#         bison \
#         flex

# RUN dnf install -y git

# RUN git clone https://github.com/OPAE/linux-dfl.git -b fpga-ofs-dev-5.15-lts /linux-dfl

# RUN cd /linux-dfl && \
#     cp /boot/config-`uname -r` .config && \
#     cat configs/dfl-config >> .config && \
#     echo 'CONFIG_LOCALVERSION="-dfl"' >> .config && \
#     echo 'CONFIG_LOCALVERSION_AUTO=y' >> .config && \
#     sed -i -r 's/CONFIG_SYSTEM_TRUSTED_KEYS=.*/CONFIG_SYSTEM_TRUSTED_KEYS=""/' .config && \
#     sed -i '/^CONFIG_DEBUG_INFO_BTF/ s/./#&/' .config && \
#     echo 'CONFIG_DEBUG_ATOMIC_SLEEP=y' >> .config && \
#     make olddefconfig

# RUN cd /linux-dfl && \
#     make -j $(nproc) && \
#     make modules_install -j $(nproc) && \
#     make install

# Dev/Build requirements
RUN dnf install -y python3 python3-pip python3-devel python3-pybind11 python3-jsonschema cmake make libuuid-devel json-c-devel gcc clang gcc-c++ hwloc-devel tbb-devel rpm-build rpmdevtools git
RUN dnf install -y libedit-devel
RUN dnf install -y libudev-devel
RUN dnf install -y libcap-devel
RUN python3 -m pip install setuptools --upgrade
RUN python3 -m pip install pyyaml jsonschema

# Open Programmable Acceleration Engine
ARG OPAE_VERSION=2.0.9-4
RUN git clone -b ${OPAE_VERSION} --single-branch https://github.com/OPAE/opae-sdk.git /opae-sdk

RUN dnf install -y systemd
RUN dnf install -y doxygen

RUN cd /opae-sdk/packaging/opae/rpm && \
    ./create fedora && \
    dnf install ./*.rpm

WORKDIR /src
