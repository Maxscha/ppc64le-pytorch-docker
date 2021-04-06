CUDA_IMAGES=("nvidia/cuda-ppc64le:11.2.2-cudnn8-devel-centos8" "nvidia/cuda-ppc64le:10.2-cudnn8-devel-centos7")
# CUDA_IMAGES=("nvidia/cuda-ppc64le:11.2.2-cudnn8-devel-centos8")

# CUDA_IMAGES=("nvidia/cuda-ppc64le:10.2-cudnn8-devel-centos7")
# 
#3.8.1 is tested
# PYTHON_VERSIONS=("3.9.2" "3.8.8" "3.8.1" "3.7.10" "3.6.9")
# 3.8.8 seems a bt broken when installing
PYTHON_VERSIONS=("3.8.1")

# GCC_VERSIONS=("10.2" "9.3" "8.4" "7.5" "6.1")
GCC_VERSIONS=("9.3" "8.4" "7.5")


PYTORCH_VERSIONS=("1.8.1" "1.7.1" "1.6.0" "1.5.1" "1.4.0")
mkdir output

#https://github.com/pytorch/vision/issues/2709

echo ${CUDA_IMAGES[@]}

base_repository_name="maxscha/cuda_pytorch_jupyter"
for base_image in ${CUDA_IMAGES[@]}
do
    for p_version in ${PYTHON_VERSIONS[@]}
    do
        for gcc_version in ${GCC_VERSIONS[@]}
        do
            cuda_cudnn8_os=$(awk -F: '{print $2}' <<< $base_image) 
            echo $base_image
            echo $p_version

            #TODO FIGURE OUT HOW TO PUT THE OUTPUT INTO A FILE
            CACHE_TAG="${base_repository_name}:${cuda_cudnn8_os}-py${p_version}-small"
            FINAL_TAG="${CACHE_TAG}-dependencies-gcc${gcc_version}"
            PYTORCH_FINAL_TAG="${FINAL_TAG}-pytorch"

            docker buildx build --platform linux/ppc64le -f cuda_with_python.dockerfile -t $CACHE_TAG --build-arg BASE_IMAGE=$base_image --build-arg PYTHON_VERSION=$p_version --progress plain .
            docker push $CACHE_TAG &
            docker buildx build --platform linux/ppc64le -f pytorch-dependencies.dockerfile -t $FINAL_TAG --build-arg BASE_IMAGE=$CACHE_TAG --build-arg GCC_VERSION=$gcc_version --progress plain .
            docker push $FINAL_TAG &
            docker buildx build --platform linux/ppc64le -f dockerfile-pytorch.dockerfile -t $PYTORCH_FINAL_TAG --build-arg BASE_IMAGE=$FINAL_TAG --progress plain .
            docker push $PYTORCH_FINAL_TAG
        done
    done
done

# for base_image in ${CUDA_IMAGES[@]}
# do
#     for p_version in ${PYTHON_VERSIONS[@]}
#     do
#         echo $base_image
#         echo $p_version
                
#         #TODO FIGURE OUT HOW TO PUT THE OUTPUT INTO A FILE
#         CACHE_TAG="${base_image}-py${p_version}"
#         FINAL_TAG="${CACHE_TAG}-dependencies"
#         PYTORCH_FINAL_TAG="${CACHE_TAG}-dependencies-pytorch"

#         docker buildx build --platform linux/ppc64le -f cuda_with_python.dockerfile -t $CACHE_TAG --build-arg BASE_IMAGE=$base_image --build-arg PYTHON_VERSION=$p_version --progress plain .
#         docker buildx build --platform linux/ppc64le -f pytorch-dependencies.dockerfile -t $FINAL_TAG --build-arg BASE_IMAGE=$CACHE_TAG --progress plain .
#         docker buildx build --platform linux/ppc64le -f dockerfile-pytorch.cpu -t $PYTORCH_FINAL_TAG --build-arg BASE_IMAGE=$FINAL_TAG --progress plain .
#     done
# done

