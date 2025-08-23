#!/bin/bash
set -e

IMAGE_DIR="./images"
SPARSE_DIR="./sparse_model"
DENSE_DIR="./dense_model"
PLY_FILE="$DENSE_DIR/fused.ply"
GLB_FILE="./output/model.glb"

mkdir -p $SPARSE_DIR $DENSE_DIR ./output

echo "🚀 Starting COLMAP reconstruction (CPU mode)..."

# Sparse + dense reconstruction in CPU mode
colmap feature_extractor --database_path $DENSE_DIR/database.db --image_path $IMAGE_DIR --SiftExtraction.use_gpu 0
colmap exhaustive_matcher --database_path $DENSE_DIR/database.db --SiftMatching.use_gpu 0
colmap mapper --database_path $DENSE_DIR/database.db --image_path $IMAGE_DIR --output_path $SPARSE_DIR
colmap image_undistorter --image_path $IMAGE_DIR --input_path $SPARSE_DIR/0 --output_path $DENSE_DIR --output_type COLMAP
colmap patch_match_stereo --workspace_path $DENSE_DIR --PatchMatchStereo.geom_consistency true
colmap stereo_fusion --workspace_path $DENSE_DIR --output_path $PLY_FILE

echo "🎨 Converting PLY → GLB..."
blender --background --python-expr "
import bpy
bpy.ops.import_mesh.ply(filepath='$PLY_FILE')
bpy.ops.export_scene.gltf(filepath='$GLB_FILE', export_format='GLB')
"

if [ -f "$GLB_FILE" ]; then
  echo "✅ GLB created at $GLB_FILE"
else
  echo "❌ GLB creation failed"
fi
