FROM python:3.6.3

MAINTAINER Bashkirtsev D.A. <bashkirtsevich@gmail.com>
LABEL maintainer="bashkirtsevich@gmail.com"

WORKDIR /usr/distr
ADD tesseract-install.sh .
RUN ./tesseract-install.sh
WORKDIR /
RUN rm -r /usr/distr
RUN pip install pytesseract==0.2.0
