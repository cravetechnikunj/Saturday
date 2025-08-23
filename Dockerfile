# ✅ Use official COLMAP prebuilt image (no compilation needed)
FROM colmap/colmap:latest

# Install Blender + Node.js for GLB export + server
RUN apt-get update && apt-get install -y blender nodejs npm python3 python3-pip

WORKDIR /app

# Copy repo content
COPY . /app

# Install Node.js deps
RUN npm install express

# Run pipeline + start server
CMD bash run_colmap.sh && node server.js
