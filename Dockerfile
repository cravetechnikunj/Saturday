FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    git cmake build-essential libboost-all-dev libglew-dev qtbase5-dev libcgal-dev \
    freeglut3-dev python3 python3-pip blender nodejs npm wget

# Install COLMAP
RUN git clone https://github.com/colmap/colmap.git /opt/colmap && \
    cd /opt/colmap && mkdir build && cd build && \
    cmake .. && make -j$(nproc) && make install

# Set working directory
WORKDIR /app

# Copy repo content
COPY . /app

# Install node dependencies
RUN npm install express
