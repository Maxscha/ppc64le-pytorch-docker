FROM maxscha/cuda_pytorch_jupyter:10.2-cudnn8-devel-centos7-py3.8.8-small-dependencies-gcc8.4.0


RUN git clone https://github.com/xianyi/OpenBLAS.git

RUN cd OpenBLAS && make TARGET=POWER9 && make PREFIX=/usr/local install

# wget http://public.dhe.ibm.com/software/server/POWER/Linux/xl-compiler/eval/ppc64le/rhel7/repodata/repomd.xml.key
# rpm --import repomd.xml.key
# wget http://public.dhe.ibm.com/software/server/POWER/Linux/xl-compiler/eval/ppc64le/rhel7/ibm-xl-compiler-eval.repo
# cp ibm-xl-compiler-eval.repo /etc/yum.repos.d/
# yum install -y libxlmass-devel.9.1.1