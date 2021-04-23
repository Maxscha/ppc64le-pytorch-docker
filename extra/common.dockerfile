# Commonly used data science libraries
#Needs to include all relevant NLP libraries

ARG BASE_IMAGE="maxscha/cuda_pytorch_jupyter:10.2-cudnn8-devel-centos7-py3.9.2-small-dependencies-gcc8.4.0-pytorchv1.8.1"

FROM $BASE_IMAGE

RUN pip3 install jupyterlab transformers pandas tqdm nltk pytorch-lightning ipywidgets 

RUN jupyter nbextension enable --py widgetsnbextension

# Needs to include java for Meteor
RUN yum install -y java-1.8.0-openjdk