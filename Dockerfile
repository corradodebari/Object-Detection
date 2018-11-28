# Set the base image
FROM nvcr.io/nvidia/tensorflow:18.04-py2
# Dockerfile author / maintainer 
MAINTAINER Name <corradodebari@gmail.com> 
# Update application repository list and install the Redis server. 
RUN apt-get update 
RUN apt-get install git 
#RUN apt-get install python-tk
RUN pip install jupyter 
RUN pip install conda 
RUN pip install pillow 
RUN pip install lxml 
RUN pip install Cython 
RUN pip install jupyter 
RUN pip install matplotlib 
RUN pip install pandas 
RUN pip install opencv-python 
RUN wget http://download.tensorflow.org/models/object_detection/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz 
RUN mkdir /shared 
RUN mkdir /images
#RUN git clone https://github.com/tensorflow/models.git
RUN git clone https://github.com/corradodebari/models.git
ADD setup.sh /workspace
ADD train.sh /workspace
ADD inference.sh /workspace
RUN chmod 755 /workspace/*.sh
ADD faster_rcnn_inception_v2_pets.config.orig /workspace
ADD object_detection_tutorial-custom.ipynb /workspace
RUN /bin/bash /workspace/setup.sh

# Expose default port
EXPOSE  8888 6006
# Set the default command
#ENTRYPOINT ["/usr/local/bin/jupyter/jupyter notebook --ip=0.0.0.0 --allow-root --notebook_dir=/workspace"]
ENV PATH "/workspace:${PATH}"
WORKDIR /workspace
ENTRYPOINT ["/bin/bash"]
