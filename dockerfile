# FROM ibmcom/powerai:1.6.2-all-ubuntu18.04-py37-ppc64le
# FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-runtime
#FROM nvidia/cuda-ppc64le:11.2.2-devel-ubi8
#Try out older cuda version because 11.2 needs newer gcc compiler which would also need to be build
#Looks at version matching https://docs.nvidia.com/deeplearning/cudnn/pdf/cuDNN-Support-Matrix.pdf
#TODO BUILD COMBINATION OF VERSIONS & PYTHON VERSIONS
ARG BASE_IMAGE=nvidia/cuda-ppc64le:11.2.2-cudnn8-devel-centos8
# ARG BASE_IMAGE
# FROM nvidia/cuda-ppc64le:10.2-cudnn8-devel-centos7
FROM ${BASE_IMAGE}
ARG PYTHON_VERSION=3.8.1
# docker pull 

# RUN yum install -y python3
# PYTHON INSTALLATION
RUN yum update -y && yum install -y gcc openssl-devel bzip2-devel libffi-devel 

RUN curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make install

# TO HAVE THE LATEST VERSION
RUN pip3 install --upgrade pip setuptools wheel


### DEPENDENCIES

ARG CMAKE_BASE_VERSION=3.18
ARG CMAKE_VERSION=3.18.4
ARG GCC_VERSION=9.3.0

RUN yum update -y && yum install -y git wget

#THIS IS THE VERSION INSTALLED BY pip which is a requirement to build pytorch add numbers of processors
RUN wget https://cmake.org/files/v${CMAKE_BASE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz && \
    tar zxf cmake-${CMAKE_VERSION}.tar.gz && \
    cd cmake-${CMAKE_VERSION} && \
    ./bootstrap && \
    make && \
    make install

#THINK ABOUT GCC COMPILER (v8)?

# RUN yum install -y cmake
RUN pip3 install ninja
RUN pip3 install numpy

#CMake is easier installed trough yum
# RUN pip3 install cmake
RUN pip3 install pyyaml setuptools cffi typing_extensions future six requests dataclasses

# No version for ppc64le
# RUN pip3 install mkl mkl-include

#https://gcc.gnu.org/wiki/InstallingGCC

RUN yum install -y bzip2 bison flex
RUN git clone git://gcc.gnu.org/git/gcc.git
RUN cd gcc && \
    git checkout releases/gcc-${GCC_VERSION} && \
    .gcc/contrib/download_prerequisites

RUN mkdir objdir && \
    cd objdir && \
    ../gcc/configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,fortran,go --enable-plugin --enable-initfini-array --disable-libgcj  --enable-gnu-indirect-function --enable-secureplt --with-long-double-128 --enable-targets=powerpcle-linux --disable-multilib --with-cpu-64=power8 --with-tune-64=power8 --build=ppc64le-redhat-linux && \
    make && \
    make install

### PYTORCH

RUN git clone --recursive https://github.com/pytorch/pytorch
# RUN pip3 install cmake
RUN export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which python3))/../"}
RUN cd pytorch && git submodule sync && git submodule update --init --recursive 
RUN cd pytorch  && python3 setup.py install
