# Needs to include
FROM maxscha/cuda_pytorch_jupyter:10.2-cudnn8-devel-centos7-py3.9.2-small-dependencies-gcc8.4.0-pytorchv1.8.1
# Jupyter Lab + Proper widget installation
RUN pip3 install jupyterlab transformers sentencepiece  pandas tqdm nltk pytorch-lightning ipywidgets 

# TODO INSTALL TORCHTEXT


#For sentencepiece openblas is required, but Pytorch does not compile if it is installed. Figure out if either can turn off blas for Pytorch, how to compile pytprch with blas, or if blas can be installed after pytorch with no problems

# Spacy has problems with numpy sometimes
RUN pip3 install spacy

RUN git clone https://github.com/pytorch/text torchtext && \ 
    cd torchtext && \
    git checkout v0.8.1 && \
    git submodule update --init --recursive && \
    python3 setup.py clean install


RUN jupyter nbextension enable --py widgetsnbextension



#Needs to include all relevant NLP libraries

# Needs to include java for Meteor
RUN yum install -y java-1.8.0-openjdk