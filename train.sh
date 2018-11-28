#!/bin/bash
export PYTHONPATH=/workspace/models/research/object_detection/utils:/workspace/models:/workspace/models/research/:/workspace/models/research/slim/:/workspace/models/research/object_detection/

# ------ CLEAN PREVIOUS TRAINING -----------------------------
cd /images
rm -Rf inference_graph
rmdir inference_graph                         
rm test.record      
rm training.record
rm training_labels.csv
rm test_labels.csv
rm /workspace/models/research/object_detection/training/*
# ------ DATA PREPARATION ------------------------------------


mkdir /workspace/models/research/object_detection/training
cp /images/labelmap.pbtxt /workspace/models/research/object_detection/training
cd /workspace/models/research/object_detection/dataset_tools
python xml_to_csv.py

python generate_tfrecord.py --csv_input=/images/training_labels.csv --image_dir=/images/training --output_path=/images/training.record

python generate_tfrecord.py --csv_input=/images/test_labels.csv --image_dir=/images/test --output_path=/images/test.record



#------------------ MODIFIY CONFIG WITH CLASSES AND TRAIN ------------------
cp /workspace/faster_rcnn_inception_v2_pets.config.orig /workspace/faster_rcnn_inception_v2_pets.config
if [ -z "$1" ] || [ -z "$2" ]
then
      echo "Error: Missing paramters. \nUsage: train.sh num_classes epochs [learning_rate]"
      exit 1 
else
       sed -i -e "s/#NUM_CLASSES#/$1/g" /workspace/faster_rcnn_inception_v2_pets.config
       sed -i -e "s/#NUM_STEPS#/$2/g" /workspace/faster_rcnn_inception_v2_pets.config
fi

if [ -z "$3" ]
then
    sed -i -e "s/#LEARNING_RATE#/0.0002/g" /workspace/faster_rcnn_inception_v2_pets.config
else
    sed -i -e "s/#LEARNING_RATE#/$3/g" /workspace/faster_rcnn_inception_v2_pets.config
fi


cp /workspace/faster_rcnn_inception_v2_pets.config /workspace/models/research/object_detection/training/

python /workspace/models/research/object_detection/legacy/train.py --logtostderr --train_dir=/workspace/models/research/object_detection/training/ --pipeline_config_path=/workspace/models/research/object_detection/training/faster_rcnn_inception_v2_pets.config

python /workspace/models/research/object_detection/export_inference_graph.py --input_type image_tensor --pipeline_config_path /workspace/models/research/object_detection/training/faster_rcnn_inception_v2_pets.config --trained_checkpoint_prefix /workspace/models/research/object_detection/training/model.ckpt-$2 --output_directory /images/inference_graph

cp /images/inference_graph/frozen_inference_graph.pb /workspace/models/research/object_detection
cd /workspace/models/research/object_detection
cp /images/labelmap.pbtxt ./training/
cd /workspace
