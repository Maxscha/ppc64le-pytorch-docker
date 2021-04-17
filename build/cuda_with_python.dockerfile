# FROM ibmcom/powerai:1.6.2-all-ubuntu18.04-py37-ppc64le
# FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-runtime
#FROM nvidia/cuda-ppc64le:11.2.2-devel-ubi8
#Try out older cuda version because 11.2 needs newer gcc compiler which would also need to be build
#Looks at version matching https://docs.nvidia.com/deeplearning/cudnn/pdf/cuDNN-Support-Matrix.pdf
#TODO BUILD COMBINATION OF VERSIONS & PYTHON VERSIONS
# ARG BASE_IMAGE=nvidia/cuda-ppc64le:11.2.2-cudnn8-devel-centos8
ARG BASE_IMAGE
# FROM nvidia/cuda-ppc64le:10.2-cudnn8-devel-centos7
FROM ${BASE_IMAGE}
ARG PYTHON_VERSION=3.8.1
# docker pull 

## Add repositories for dependencies for python3, only for centos8 not for centos7
RUN yum install -y yum-utils 
#    yum-config-manager --add-repo  http://mirror.centos.org/centos/7/PowerTools/ppc64le/os/
    # yum-config-manager --add-repo http://mirror.centos.org/centos/8-stream/BaseOS/ppc64le/os/ && \
    # yum-config-manager --add-repo http://mirror.centos.org/centos/8-stream/PowerTools/ppc64le/os/

# RUN yum install -y python3
# PYTHON INSTALLATION
RUN yum update -y && yum install -y gcc openssl-devel bzip2-devel libffi-devel && \
    yum-builddep python3 -y

RUN curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j4 && \
    make install && \
    rm -rf Python-${PYTHON_VERSION}.tgz Python-${PYTHON_VERSION} 


# TO HAVE THE LATEST VERSION
RUN pip3 install --upgrade pip setuptools wheel



# RUN pip3 install jupyterlab ipywidgets widgetsnbextension jupyterlab_widgets

# RUN pip3 install nltk pandas numpy sklearn

# RUN pip3 install transformers==4.3.2 pytorch-lightning==1.2.2
