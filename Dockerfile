FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    dos2unix \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /workspace

# Copy requirements.txt (make sure this is aligned with HunyuanVideo's requirements)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Flash Attention v2 for acceleration
RUN pip install git+https://github.com/Dao-AILab/flash-attention.git@v2.5.9.post1

# Download pretrained models (adjust URL based on specific models you're using)
RUN wget -P /workspace/models https://path-to-pretrained-model

# Copy HunyuanVideo repository into the container (you can clone instead if local repo isn't available)
COPY . /workspace/HunyuanVideo

# Set up the environment for running HunyuanVideo
RUN conda env create -f /workspace/HunyuanVideo/environment.yml && \
    conda clean --all

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]
