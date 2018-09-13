FROM python:3.6.3

MAINTAINER Bashkirtsev D.A. <bashkirtsevich@gmail.com>
LABEL maintainer="bashkirtsevich@gmail.com"

COPY tessdata /tessdata
ENV TESSDATA_PREFIX=/tessdata

RUN mkdir /tmp/tesseract && \
    echo "Update & upgrade" && \
    apt-get -y update && \
    apt-get -y upgrade && \
    echo "Install building tools" && \
    apt-get -y install autoconf-archive automake g++ libtool libleptonica-dev pkg-config tesseract-ocr-rus && \
    echo "Download leptonica" && \
    wget http://www.leptonica.com/source/leptonica-1.75.3.tar.gz  && \
    tar xvf leptonica-1.75.3.tar.gz && \
    echo "Compile leptonica" && \
    cd leptonica-1.75.3 && \
    ./configure && \
    make && \
    make install && \
    cd - && \
    echo "Clone tesseract 4 source" && \
    git clone https://github.com/tesseract-ocr/tesseract.git tesseract-ocr && \
    cd tesseract-ocr/ && \
    git checkout tags/4.0.0-beta.1 && \
    echo "Compile tesseract" && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig && \
    cd /tmp && \
    rm -rf /tmp/tesseract && \
    pip install pytesseract==0.2.0