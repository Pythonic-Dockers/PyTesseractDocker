FROM python:3.8

MAINTAINER Bashkirtsev D.A. <bashkirtsevich@gmail.com>
LABEL maintainer="bashkirtsevich@gmail.com"

COPY tessdata /tessdata
ENV TESSDATA_PREFIX=/tessdata

ARG TAG=4.0.0-beta.1

RUN mkdir /tmp/tesseract && \
    echo "Update & upgrade" && \
    apt-get -y update && \
    apt-get -y upgrade && \
    echo "Install building tools" && \
    apt-get -y install autoconf-archive automake g++ libtool libleptonica-dev pkg-config tesseract-ocr-rus && \
    echo "Download leptonica" && \
    wget http://www.leptonica.org/source/leptonica-1.79.0.tar.gz  && \
    tar xvf leptonica-1.79.0.tar.gz && \
    echo "Compile leptonica" && \
    cd leptonica-1.79.0 && \
    ./configure && \
    make && \
    make install && \
    cd - && \
    echo "Clone tesseract 4 source" && \
    git clone https://github.com/tesseract-ocr/tesseract.git tesseract-ocr && \
    cd tesseract-ocr/ && \
    git checkout tags/${TAG} && \
    echo "Compile tesseract" && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig && \
    cd /tmp && \
    rm -rf /tmp/tesseract && \
    pip install pytesseract
