FROM ubuntu:14.04
ARG CMAKE_URL=https://cmake.org/files/LatestRelease/cmake-3.12.1.tar.gz
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get -qq update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl mesa-common-dev libmicrohttpd-dev libssl-dev libhwloc-dev software-properties-common && \
  add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
  apt-get -qq update && \
  apt-get install -y gcc-6 g++-6 make

RUN \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 1 --slave /usr/bin/g++ g++ /usr/bin/g++-6 && \
  echo "Downloading cmake" && \
  curl -o /tmp/cmake.tar.gz ${CMAKE_URL} && \
  tar -xzf /tmp/cmake.tar.gz -C /tmp/ && \
  cd /tmp/cmake-*/ && ./configure && make && sudo make install && \
  update-alternatives --install /usr/bin/cmake cmake /usr/local/bin/cmake 1 --force && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /build

ARG CUDA_TOOLKIT_URL=https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run

RUN \
  cd /build && \
  curl -LO ${CUDA_TOOLKIT_URL}

RUN \
  cd /build && \
  sh ./$(basename "$CUDA_TOOLKIT_URL") --silent --toolkit --no-drm && \
  rm ./$(basename "$CUDA_TOOLKIT_URL")

ARG XMRSTAK_GIT_URL=https://github.com/fireice-uk/xmr-stak
ARG XMRSTAK_GIT_BRANCH=master


RUN \
  cd /build && \
  rm -rf xmr-stak && \
  apt-get -qq update && \
  apt-get install -y git && \
  git clone ${XMRSTAK_GIT_URL} --depth=1 xmr-stak && \
  mkdir ./xmr-stak/build

RUN \
  apt-get install -y opencl-headers ocl-icd-opencl-dev && \
  cd /build/xmr-stak/build && \
  cmake -DCMAKE_LINK_STATIC=ON -DCUDA_ENABLE=ON -DOpenCL_ENABLE=ON ../ && \
  cmake --build .
