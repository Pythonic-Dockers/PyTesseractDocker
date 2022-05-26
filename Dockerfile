FROM python:3.8 as tess_builder

ARG TAG=5.0.1

WORKDIR /src/tesseract

RUN apt update && \
    apt -yq install poppler-utils autoconf-archive automake g++ libtool libleptonica-dev pkg-config tesseract-ocr-rus && \
    wget http://www.leptonica.org/source/leptonica-1.79.0.tar.gz  && \
    tar xvf leptonica-1.79.0.tar.gz && \
    cd leptonica-1.79.0 && \
    ./configure && \
    make && \
    make install && \
    cd - && \
    git clone https://github.com/tesseract-ocr/tesseract.git tesseract-ocr && \
    cd tesseract-ocr/ && \
    git checkout tags/${TAG} && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# ------------------------------------

FROM python:3.8 as tesseract

ENV TESSDATA_PREFIX=/tessdata

RUN apt update && \
    apt -yq install poppler-utils libimage-exiftool-perl locales libreoffice-core --no-install-recommends && \
    apt autoremove -y && \
    pip install pytesseract && \
    sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    rm -rf /var/lib/apt/lists/*

COPY tessdata /tessdata
COPY --from=tess_builder /usr/local/lib/liblept.so.5.0.4 /usr/local/lib/liblept.so.5.0.4
COPY --from=tess_builder /usr/local/lib/liblept.a /usr/local/lib/liblept.a
COPY --from=tess_builder /usr/local/lib/liblept.la /usr/local/lib/liblept.la
COPY --from=tess_builder /usr/local/lib/liblept.so.5.0.4 /usr/local/lib/liblept.so.5.0.4
COPY --from=tess_builder /usr/local/lib/libtesseract.so.5.0.0 /usr/local/lib/libtesseract.so.5.0.0
COPY --from=tess_builder /usr/local/bin/tesseract /usr/local/bin/tesseract

RUN cd /usr/local/lib/ \
   && ln -s liblept.so.5.0.4 liblept.so \
   && ln -s liblept.so.5.0.4 liblept.so.5 \
   && ln -s liblept.a libleptonica.a \
   && ln -s liblept.la libleptonica.la \
   && ln -s liblept.so libleptonica.so \
   && cd /usr/local/bin/ \
   && ln -s libtesseract.so.5.0.0 libtesseract.so \
   && ln -s libtesseract.so.5.0.0 libtesseract.so.5
