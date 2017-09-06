#!/usr/bin/env bash

CUDA=1
while [ "$1" != "" ]; do
    case $1 in
        -nc | --no-cuda )       CUDA=0
                                ;;
        * )                     exit 1
    esac
    shift
done

CUDA_PATH=/usr/local/cuda/

python setup.py build_ext --inplace
rm -rf build
cd roi_pooling/src/cuda

if [ "$CUDA" = 1 ]; then
    echo "Compiling roi pooling kernels by nvcc..."
    nvcc -c -o roi_pooling.cu.o roi_pooling_kernel.cu \
	     -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -arch=sm_32
fi

#g++ -std=c++11 -shared -o roi_pooling.so roi_pooling_op.cc \
#	roi_pooling_op.cu.o -I $TF_INC -fPIC -lcudart -L $CUDA_PATH/lib64
cd ../../
python build.py
