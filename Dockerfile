# Dockerfile for building general development
# environment for Data Science Analytics
FROM ubuntu:14.04
LABEL maintainer "michaelchan_wahyan@yahoo.com.hk"

# REFERENCE
# https://github.com/potree/PotreeConverter/issues/180

ENV SHELL=/bin/bash \
    TZ=Asia/Hong_Kong \
    PYTHONIOENCODING=UTF-8 \
    AIRFLOW_HOME=/opt/airflow \
    AIRFLOW_GPL_UNIDECODE=yes \
    PATH=$PATH:/bin:/usr/local/sbin:/usr/local/bin:/usr/local/lib:/usr/lib:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get -y update

# INSTALL BOOST CMAKE BUILD-ESSENTIAL
RUN apt-get -y install \
        libboost-dev \
        libboost-system-dev \
        libboost-thread-dev \
        libboost-filesystem-dev \
        libboost-program-options-dev \
        libboost-regex-dev
RUN apt-get -y install \
        build-essential \
        wget git screen ca-certificates \
        musl-dev net-tools curl htop apt-utils
RUN cd / ; wget https://cmake.org/files/v3.19/cmake-3.19.4-Linux-x86_64.sh ;\
    yes | sh cmake-3.19.4-Linux-x86_64.sh ;\
    ln -s /cmake-3.19.4-Linux-x86_64/bin/ccmake    /usr/bin/ccmake ;\
    ln -s /cmake-3.19.4-Linux-x86_64/bin/cmake     /usr/bin/cmake ;\
    ln -s /cmake-3.19.4-Linux-x86_64/bin/cmake-gui /usr/bin/cmake-gui ;\
    ln -s /cmake-3.19.4-Linux-x86_64/bin/cpack     /usr/bin/cpack ;\
    ln -s /cmake-3.19.4-Linux-x86_64/bin/ctest     /usr/bin/ctest

# INSTALL GCC G++ 7.4
RUN apt-get -y install software-properties-common
RUN apt-get -y update ;\
    apt-add-repository ppa:ubuntu-toolchain-r/test
RUN apt-get -y update ;\
    apt-get -y install \
        gcc-7 \
        g++-7 \
        cpp-7 ;\
    mv /usr/bin/gcc /usr/bin/gcc.bak ;\
    mv /usr/bin/g++ /usr/bin/g++.bak ;\
    mv /usr/bin/cpp /usr/bin/cpp.bak ;\
    ln -s /usr/bin/gcc-7 /usr/bin/gcc ;\
    ln -s /usr/bin/g++-7 /usr/bin/g++ ;\
    ln -s /usr/bin/cpp-7 /usr/bin/cpp

# INSTALL LAStools
RUN cd / ; git clone --depth 1 -b master https://github.com/m-schuetz/LAStools.git
RUN cd /LAStools/LASzip ;\
    mkdir build ;\
    cd build ;\
    cmake -DCMAKE_BUILD_TYPE=Release .. ;\
    make
RUN cd / ; wget https://github.com/potree/PotreeConverter/archive/1.6.tar.gz
RUN cd / ; tar -zxvf 1.6.tar.gz
RUN cd /PotreeConverter-1.6 ;\
    mkdir build ;\
    cd build;\
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DLASZIP_INCLUDE_DIRS=/LAStools/LASzip/dll \
          -DLASZIP_LIBRARY=/LAStools/LASzip/build/src/liblaszip.so .. ;\
    make ;\
    make install

COPY [ ".bashrc" , ".vimrc"               , "/root/"                 ]

CMD [ "/bin/bash" ]
