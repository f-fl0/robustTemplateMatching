FROM python:3.6-slim

COPY requirements.txt requirements.txt
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        libc-dev \
        libgl1-mesa-glx \
        libglib2.0-0 \
        wget \
    && python3 -m pip install --no-cache-dir --upgrade pip \
    && python3 -m pip install --no-cache-dir -r requirements.txt \
    && rm -rf /var/lib/apt/lists/*

RUN wget --quiet --show-progress --progress=bar:force:noscroll https://download.pytorch.org/models/vgg13-c768596a.pth \
        -P /root/.torch/models/

WORKDIR /ws
COPY . .
RUN cd cython_files \
    && python setup.py build_ext --inplace
