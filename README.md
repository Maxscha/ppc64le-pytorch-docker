# ppc64le-pytorch-docker

This repository collects various dockerfiles & scripts to cross-build working docker images of multiple version combinations for Cuda, Cudnn, Python, & Pytorch for `IBM Power9` computers with `Tesla V100-SXM2-32GB` gpus. The build steps are seperated in multiple dockerfiles to easily build, tag, & push different version combinations.

### Requirements
- Docker
- [Docker Buildkit](https://github.com/docker/buildx)
- For building pytorch with buildkit more than 16GB of RAM is required

### How to build all version combinations
1. `cd build`
2. Adapt the required versions in `build_all_versions.sh` to your need
3. Run `./build_all_versions.sh`
4. Depending on the number of images & combinations build this process 

### Working & Tested Combinations
*In Progress*

### Dockerhub

Build images can be found in the corrosponding [Dockerhub Repository](https://hub.docker.com/repository/docker/maxscha/cuda_pytorch_jupyter)



### Todos
- [ ] Add Torchvision & Torchtext
- [ ] Streamline version combinations, by reducing the number of needed dependency version. (e.g. GCC)
- [ ] Reduce image build size
- [ ] Add Centos8 Builds
- [ ] Add Ubuntu-Based Builds