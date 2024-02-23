# Base image
# FROM --platform=linux/amd64 nvidia/cuda:12.1.0-runtime-ubuntu22.04
FROM --platform=linux/amd64 python:3.11.7-slim-bullseye 
# Set the timezone
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Install system dependencies in a single layer
RUN apt-get update && apt-get upgrade -yq && apt-get install -yq \
    gcc \
    g++ \
    make \
    wget \
    libgl1 \
    libglib2.0-0 \
    git \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /stable-diffusion-webui

# Define the version numbers for torch and torchvision
ENV TORCH_VERSION=2.2
ENV TORCHVISION_VERSION=0.17.0

ENV TORCH_COMMAND="pip install torch==$TORCH_VERSION torchvision==$TORCHVISION_VERSION --no-cache-dir"
RUN pip install torch==$TORCH_VERSION torchvision==$TORCHVISION_VERSION --no-cache-dir

COPY . /stable-diffusion-webui/

ENV PYTHONUNBUFFERED=1
RUN python3 launch.py --skip-torch-cuda-test --exit
RUN pip install opencv-python --upgrade --no-cache-dir

RUN rm -rf models
RUN rm -rf outputs
RUN rm -rf configs
RUN rm -rf embeddings
RUN rm -rf extensions
CMD ["python3", "launch.py", "--skip-torch-cuda-test"]