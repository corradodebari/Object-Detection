#!/bin/bash
export PYTHONPATH=/workspace/models/research/object_detection:/workspace/models:/workspace/models/research/:/workspace/models/research/slim/
cp /workspace/object_detection_tutorial-custom.ipynb /images
cd /images

jupyter notebook --ip=0.0.0.0 --allow-root
