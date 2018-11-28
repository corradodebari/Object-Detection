#!/bin/bash 
export PYTHONPATH=/workspace/models:/workspace/models/research/:/workspace/models/research/slim/
#cd /workspace/models
#git checkout 7922c9e
sed -i -e 's/range(num_boundaries)/list(range(num_boundaries))/g' /workspace/models/research/object_detection/utils/learning_schedules.py
cd /workspace
cp /workspace/object_detection_tutorial-custom.ipynb /images
mv /workspace/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz /workspace/models/research/object_detection/ 
gunzip /workspace/models/research/object_detection/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz 
tar xvf /workspace/models/research/object_detection/faster_rcnn_inception_v2_coco_2018_01_28.tar --directory=/workspace/models/research/object_detection/ 
wget https://github.com/google/protobuf/releases/download/v3.5.1/protoc-3.5.1-linux-x86_64.zip 
mkdir protoc 
mv protoc-3.5.1-linux-x86_64.zip /workspace/protoc 
cd /workspace/protoc/
unzip protoc-3.5.1-linux-x86_64.zip
export PATH=/workspace/protoc/bin:$PATH
cd /workspace/models/research/

protoc object_detection/protos/*.proto --python_out=.
python setup.py build
python setup.py install
cd /workspace/models/research/object_detection/dataset_tools
wget https://raw.githubusercontent.com/corradodebari/DL-workshop/master/xml_to_csv.py
wget https://raw.githubusercontent.com/corradodebari/DL-workshop/master/generate_tfrecord.py
cd /workspace
#apt-get install python-tk
