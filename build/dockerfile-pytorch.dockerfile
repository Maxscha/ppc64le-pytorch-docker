ARG BASE_IMAGE=test_git

FROM $BASE_IMAGE

ARG PYTORCH_VERSION="v1.7.1"
# ARG PYTHON_VERSION=3.8
# ARG WITH_TORCHVISION=0
# https://gist.github.com/1duo/38af1abd68a2c7fe5087532ab968574e
# RUN curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
#      chmod +x ~/miniconda.sh && \
#      ~/miniconda.sh -b -p /opt/conda && \
#      rm ~/miniconda.sh && \
#      /opt/conda/bin/conda install -y python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl mkl-include ninja cython typing && \
#      /opt/conda/bin/conda install -y -c pytorch magma-cuda100 && \
#      /opt/conda/bin/conda clean -ya
# ENV PATH /opt/conda/bin:$PATH

# RUN yum install -y wget

RUN git clone --recursive https://github.com/pytorch/pytorch
# RUN pip3 install cmake
RUN export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which python3))/../"}
RUN cd pytorch && git checkout $PYTORCH_VERSION && git submodule sync && git submodule update --init --recursive 
RUN cd pytorch  && BUILD_BINARY=0 BUILD_TEST=0 TORCH_CUDA_ARCH_LIST="5.0" python3 setup.py install

#https://gcc.gnu.org/wiki/InstallingGCC
# yum install -y bzip2 bison flex
# git clone git://gcc.gnu.org/git/gcc.git
# git checkout releases/gcc-6.1.0
#.gcc/contrib/download_prerequisites
#mkdir objdir
#cd objdir
#$PWD/../gcc/configure --prefix=$HOME/GCC --enable-languages=c,c++,fortran,go

#Compiling version is installed like this but wrong home directoy
#$PWD/../gcc/configure --prefix=$HOME/GCC --enable-languages=c,c++,fortran,go

# Orginal gcc is compiled like this
# ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto --enable-plugin --enable-initfini-array --disable-libgcj --with-isl=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-ppc64le-redhat-linux/isl-install --with-cloog=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-ppc64le-redhat-linux/cloog-install --enable-gnu-indirect-function --enable-secureplt --with-long-double-128 --enable-targets=powerpcle-linux --disable-multilib --with-cpu-64=power8 --with-tune-64=power8 --build=ppc64le-redhat-linux

# $PWD/../gcc/configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,fortran,go --enable-plugin --enable-initfini-array --disable-libgcj  --enable-gnu-indirect-function --enable-secureplt --with-long-double-128 --enable-targets=powerpcle-linux --disable-multilib --with-cpu-64=power8 --with-tune-64=power8 --build=ppc64le-redhat-linux
#
#-- Checking for [blas]
#--   Library blas: BLAS_blas_LIBRARY-NOTFOUND
#-- Cannot find a library with BLAS API. Not using BLAS.
# -- Cannot find a library with LAPACK API. Not using LAPACK.
# disabling ROCM because NOT USE_ROCM is set

