BASE_IMAGE="maxscha/cuda_pytorch_jupyter:10.2-cudnn8-devel-centos7-py3.9.2-small-dependencies-gcc8.4.0-pytorchv1.8.1"

#Choose corrosponding on Pytorch version and recommendation here https://github.com/pytorch/text
TORCHTEXT_VERSION="v0.9.1-rc1"

#Choose corrosponding on Pytorch version and recommendation here https://github.com/pytorch/vision
TORCHVISION_VERSION="v0.9.1"


TAG=$BASE_IMAGE-TEXT$TORCHTEXT_VERSION
docker buildx build --platform linux/ppc64le -f torchtext.dockerfile -t $TAG --build-arg BASE_IMAGE=$BASE_IMAGE --build-arg TORCHTEXT_VERSION=$TORCHTEXT_VERSION --progress plain . 
# docker push $TAG

BASE_IMAGE=$TAG
TAG=$TAG-VISION$TORCHVISION_VERSION
docker buildx build --platform linux/ppc64le -f torchvision.dockerfile -t $TAG --build-arg BASE_IMAGE=$BASE_IMAGE --build-arg TORCHVISION_VERSION=$TORCHVISION_VERSION --progress plain . 


BASE_IMAGE=$TAG
TAG=$TAG-common
docker buildx build --platform linux/ppc64le -f common.dockerfile -t $TAG --build-arg BASE_IMAGE=$BASE_IMAGE --progress plain . 

docker push $TAG

