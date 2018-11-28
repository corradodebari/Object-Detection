# Object-Detection
Docker image for object detection, based on Google Tensorflow Object Detection API, to train on your own dataset.  
I've approached months ago the Object Detection through Faster R-CNN but, even if with standard COCO pre-trained dataset it's easy to experiment and apply this deep learning network model, I've found actually more tricky to train on my own dataset than single object recognition models.  
So, inspired by tutorials like: ["How To Train an Object Detection Classifier for Multiple Objects Using TensorFlow (GPU) on Windows 10"](https://github.com/EdjeElectronics/TensorFlow-Object-Detection-API-Tutorial-Train-Multiple-Objects-Windows-10#3-gather-and-label-pictures) I've defined a Docker image to simplify the training phase.    
To proceed you need to follow these steps:

## 1. Get a Cloud Node
Get a certified cloud image for [NVIDIA GPU Cloud](https://ngc.nvidia.com) on [Oracle Cloud Infrastructure](https://docs.cloud.oracle.com/iaas/Content/Compute/References/ngcimage.htm):

* US Region: **us-ashburn-1** 
*ocid1.image.oc1.iad.aaaaaaaaikn6ub6heefqxbe5fkiv4otbfe6ivza6y7di5khnkxkyvf2bkdta*
* EU Region: **eu-frankfurt-1**  
*ocid1.image.oc1.eu-frankfurt-1.aaaaaaaauwuafl6uze6bnusphnn6y2mr5y7ajavx4kza7glyrqggxlnbo4zq*    

These are Ubuntu 16.04.3 images, with **nvidia-docker** pre-configured to use GPU shapes: no other configurations needed.

## 2. Github project download
With command:
```
#git clone https://github.com/corradodebari/Object-Detection.git
```
download into the cloud node this GitHub projects.
Into docker directory you'll find:
* **Dockerfile**     
* **build.sh**                         
* **setup.sh**
* **train.sh**
* **inference.sh**
* **build.sh**
* **faster_rcnn_inception_v2_pets.config.orig**
* **object_detection_tutorial-custom.ipynb**

eventually you may tune the model config file **faster_rcnn_inception_v2_pets.config.orig**.  
Set permission on script files running:
```
#chmod 755 *.sh
```

## 3. Build the Docker Image
In */Object-Detection* directory build a local Docker image:
```
#./build.sh [image_name]
```
where:
* **image_name**: is optional, by default is "objdetect", and represent the image name in your local Docker repository

## 4. Prepare dataset
With a tool like [LabelImg](https://github.com/tzutalin/labelImg) or [RectLabel](https://rectlabel.com)
prepare a training and test dataset in PASCAL VOC XML format, the format used by ImageNet.
Put files in the following directories:
```
--dataset/
         |--training/
         |--test/
         |--labelmap.pbtxt
```
with *labelmap.pbtxt* file made in this way:
```
item {
  id:1
  name: 'class_1'
}
item {
  id:2
  name: 'class_2'
}
...

```
*Name*s values, i.e. *class_1*, *class_2*, etc., must match with the class names used with LabelImg tools to label the objects.

**NOTE**: do not create any other subdirectories for classes. Put the image files + xml label files straight into /test and /training 
directories, otherwise they will be ignored

## 5. Run container
```
#nvidia-docker run -it -d -v [local_dir]:/shared -v [local_dataset_dir]:/images -p 8888:8888 -p 6006:6006 --name [container_name] -t [image_name]
```

where:  
* **local_dir**: to share artifacts in host with container   
* **local_dataset_dir**: directory in which it will be found the training/test Pascal VOC dataset   
* **container_name**: container name to simplify operations  
* **image_name**: image name provided at step [**3**]  

**Example:**
```
#nvidia-docker run -it -d -v /home/ubuntu:/shared -v /home/ubuntu/dataset:/images -p 8888:8888 -p 6006:6006 --name objdetect1 -t objdetect
```
## 6. Training
With docker container running (if not, start it with command: *#docker start [container_name]* )
```bash
#docker exec container_name train.sh [num_classes] [num_epochs] [learning_rate] 
```
where:  
* **container_name**: name previously set   
* **num_classes**: number of classes   
* **num_epochs**: number of learning iteration steps   
* **learning_rate**: optional, by default 0.0002  

**Example**:
```
    #nvidia-docker exec objdetect1 train.sh 1 40000 0.0001
```


## 7. Test
To test, run jupyter notebook on port 8888:
```bash
#nvidia-docker exec container_name inference.sh
```
**Example**:
```bash
#nvidia-docker exec objdetect1 inference.sh
```
Get the Jupyter Notebook ID and run the test notebook. Upload the images you want to test into directory: 
**/test_images**

**NOTE**:
You can re-train the model as many times as you want, returning on step [**6**] if you aren't satisfied by detection error rate. At the end you can find the trained frozen model ".pb" into:   
  
*local_dataset_dir*/inference_graph/frozen_inference_graph.pb
