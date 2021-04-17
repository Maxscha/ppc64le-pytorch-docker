#CUDA_IMAGES=("nvidia/cuda-ppc64le:11.2.2-cudnn8-devel-centos8" "nvidia/cuda-ppc64le:10.2-cudnn8-devel-centos7")
CUDA_IMAGES=("nvidia/cuda-ppc64le:10.2-cudnn8-devel-centos7")
#Right now only centos7 because of long-term support

#3.8.1 is tested
PYTHON_VERSIONS=("3.9.2" "3.8.8" "3.8.1" "3.7.10" "3.6.9")

# GCC_VERSIONS=("10.2.0" "9.3.0" "8.4.0" "7.5.0" "6.1.0")
GCC_VERSIONS=("10.2.0" "8.4.0" "7.5.0" "6.1.0")
#VERSION 10.2 & 9.3 are to old for pytorch 1.7.1 but want to compile 10.2 anyway just in case

PYTORCH_VERSIONS=("master" "v1.8.1" "v1.7.1" "v1.6.0" "v1.5.1" "v1.4.0")

RUN_TIMESTAMP=$(date '+%Y-%m-%d-%H_%M')
echo $RUN_TIMESTAMP
LOG_PATH=log/$RUN_TIMESTAMP
mkdir -p $LOG_PATH

#https://github.com/pytorch/vision/issues/2709

echo ${CUDA_IMAGES[@]}

base_repository_name="maxscha/cuda_pytorch_jupyter"
for base_image in ${CUDA_IMAGES[@]}
do
    for p_version in ${PYTHON_VERSIONS[@]}
    do
        cuda_cudnn8_os=$(awk -F: '{print $2}' <<< $base_image)
        echo $base_image
        echo $p_version

	    CUDA_PYTHON_VERSION="${cuda_cudnn8_os}-py${p_version}-small"
        CUDA_PYTHON_TAG="${base_repository_name}:${CUDA_PYTHON_VERSION}"

        LOG_FILE=$LOG_PATH/${CUDA_PYTHON_VERSION}.txt

        unbuffer docker buildx build --platform linux/ppc64le -f cuda_with_python.dockerfile -t $CUDA_PYTHON_TAG --build-arg BASE_IMAGE=$base_image --build-arg PYTHON_VERSION=$p_version --progress plain . 2>&1 | tee $LOG_FILE
       	docker push $CUDA_PYTHON_TAG 
	
        for gcc_version in ${GCC_VERSIONS[@]}
            do
                echo $gcc_version

                #TODO FIGURE OUT HOW TO PUT THE OUTPUT INTO A FILE
                DEPENDENCIES_VERSION="${CUDA_PYTHON_VERSION}-dependencies-gcc${gcc_version}"
                DEPENDENCIES_TAG="${base_repository_name}:${DEPENDENCIES_VERSION}"

                LOG_FILE=$LOG_PATH/${DEPENDENCIES_VERSION}.txt
                unbuffer docker buildx build --platform linux/ppc64le -f pytorch-dependencies.dockerfile -t $DEPENDENCIES_TAG --build-arg BASE_IMAGE=$CUDA_PYTHON_TAG --build-arg GCC_VERSION=$gcc_version --progress plain . 2>&1 | tee $LOG_FILE
                docker push $DEPENDENCIES_TAG 

                for pt_version in ${PYTORCH_VERSIONS[@]}
                do
                    PYTORCH_VERSION="${DEPENDENCIES_VERSION}-pytorch${pt_version}"
                    PYTORCH_TAG="${base_repository_name}:${PYTORCH_VERSION}"

    	            LOG_FILE=$LOG_PATH/${PYTORCH_VERSION}.txt
                    unbuffer docker buildx build --platform linux/ppc64le -f dockerfile-pytorch.dockerfile -t $PYTORCH_TAG --build-arg BASE_IMAGE=$DEPENDENCIES_TAG --build-arg PYTORCH_VERSION=pt_version --progress plain . 2>&1 | tee $LOG_FILE
                    docker push $PYTORCH_TAG
                done
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

