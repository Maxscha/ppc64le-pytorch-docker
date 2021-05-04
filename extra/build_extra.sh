
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

