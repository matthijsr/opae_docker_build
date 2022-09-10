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

# # Open Programmable Acceleration Engine
# ARG OPAE_VERSION=2.1.0-2
# RUN git clone -b ${OPAE_VERSION} --single-branch https://github.com/OPAE/opae-sdk.git /opae-sdk && \
#     mkdir -p /opae-sdk/build && \
#     cd /opae-sdk/build && \
#     cmake3 \
#     -DCMAKE_BUILD_TYPE=Debug \
#     -DOPAE_BUILD_SIM=On \
#     -DOPAE_BUILD_LIBOPAE_PY=On \
#     -DOPAE_BUILD_LIBOPAEVFIO=Off \
#     -DOPAE_BUILD_PLUGIN_VFIO=Off \
#     -DOPAE_BUILD_EXTRA_TOOLS=On  \
# 	-DCMAKE_INSTALL_PREFIX=/usr /opae-sdk && \
#     make -j && \
#     make install && \
#     rm -rf /opae-sdk

WORKDIR /root
COPY artifacts/opae-sdk/scripts/build-rpms.sh /scripts/build-rpms.sh
COPY artifacts/opae-sdk/scripts/test-rpms.sh /scripts/test-rpms.sh
ENTRYPOINT [ "/scripts/build-rpms.sh" ]
