ARG BASE_IMAGE="maxscha/cuda_pytorch_jupyter:10.2-cudnn8-devel-centos7-py3.9.2-small-dependencies-gcc8.4.0-pytorchv1.8.1"

FROM $BASE_IMAGE

ARG TORCHTEXT_VERSION="v0.9.1-rc1"

# Spacy has problems with numpy sometimes
RUN pip3 install spacy

RUN git clone https://github.com/pytorch/text torchtext && \ 
    cd torchtext && \
    git checkout $TORCHTEXT_VERSION && \
    git submodule update --init --recursive && \
    python3 setup.py clean install

