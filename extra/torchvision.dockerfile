ARG BASE_IMAGE="maxscha/cuda_pytorch_jupyter:10.2-cudnn8-devel-centos7-py3.9.2-small-dependencies-gcc8.4.0-pytorchv1.8.1"

FROM $BASE_IMAGE

ARG PILLOW_VERSION="8.2.0"
ARG TORCHVISION_VERSION="v0.9.1"

#PILLOW
RUN yum install -y jpeg-dev zlib-dev ghostscript lcms2-devel libffi-devel libimagequant-devel libjpeg-devel     libraqm-devel libtiff-devel libwebp-devel libjpeg-devel

RUN git clone https://github.com/python-pillow/Pillow 

RUN cd Pillow && \
    git checkout $PILLOW_VERSION && \ 
    MAX_CONCURRENCY=1 python3 setup.py build_ext  install

RUN yum install -y freetype-devel ghostscript lcms2-devel libffi-devel libjpeg-devel libtiff-devel libwebp-devel openjpeg2-devel tcl-devel tk-devel xorg-x11-server-Xvfb zlib-devel yum install freetype-devel ghostscript lcms2-devel libffi-devel libjpeg-devel libtiff-devel libwebp-devel openjpeg2-devel tcl-devel tk-devel xorg-x11-server-Xvfb zlib-devel 

RUN git clone https://github.com/pytorch/vision && \
    cd vision && \
    git checkout $TORCHVISION_VERSION && \
    python3 setup.py install