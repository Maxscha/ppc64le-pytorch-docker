ARG BASE_IMAGE=cuda_with_python


FROM ${BASE_IMAGE}

ARG CMAKE_BASE_VERSION=3.18
ARG CMAKE_VERSION=3.18.4
ARG GCC_VERSION=8.4.0

RUN yum update -y && yum install -y git wget

#THIS IS THE VERSION INSTALLED BY pip which is a requirement to build pytorch add numbers of processors
RUN wget https://cmake.org/files/v${CMAKE_BASE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz && \
    tar zxf cmake-${CMAKE_VERSION}.tar.gz && \
    cd cmake-${CMAKE_VERSION} && \
    ./bootstrap && \
    make -j$(nproc) && \
    make install && \
    rm -rf cmake-${CMAKE_VERSION}.tar.gz cmake-${CMAKE_VERSION}

#THINK ABOUT GCC COMPILER (v8)?
RUN pip3 install ninja numpy


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
    ./contrib/download_prerequisites

RUN mkdir objdir && \
    cd objdir && \
    ../gcc/configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,fortran,go --enable-plugin --enable-initfini-array --disable-libgcj  --enable-gnu-indirect-function --enable-secureplt --with-long-double-128 --enable-targets=powerpcle-linux --disable-multilib --with-cpu-64=power8 --with-tune-64=power8 --build=ppc64le-redhat-linux && \
    make -j$(nproc)  && \
    make install
    
#$PWD/../gcc/configure --prefix=$HOME/GCC --enable-languages=c,c++,fortran,go

#Compiling version is installed like this but wrong home directoy
#$PWD/../gcc/configure --prefix=$HOME/GCC --enable-languages=c,c++,fortran,go

# Orginal gcc is compiled like this
# ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto --enable-plugin --enable-initfini-array --disable-libgcj --with-isl=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-ppc64le-redhat-linux/isl-install --with-cloog=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-ppc64le-redhat-linux/cloog-install --enable-gnu-indirect-function --enable-secureplt --with-long-double-128 --enable-targets=powerpcle-linux --disable-multilib --with-cpu-64=power8 --with-tune-64=power8 --build=ppc64le-redhat-linux

# $PWD/
