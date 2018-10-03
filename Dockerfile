FROM tensorflow/tensorflow:nightly-devel-gpu-py3

ARG path=/usr/src/object_detection

RUN pip3 install --upgrade tensorflow-gpu==1.9

RUN pip3 install Cython
RUN pip3 install contextlib2
RUN pip3 install image
RUN pip3 install 'prompt-toolkit==2.0.4'

RUN mkdir -p $path
WORKDIR $path

RUN mkdir Github
RUN cd $path/Github && git clone https://github.com/tensorflow/models.git
RUN cd $path/Github && git clone https://github.com/cocodataset/cocoapi.git
RUN sed -i 's/python /python3 /g' $path/Github/cocoapi/PythonAPI/Makefile
RUN cd $path/Github/cocoapi/PythonAPI && make
RUN cp -r $path/Github/cocoapi/PythonAPI/pycocotools $path/Github/models/research/

RUN mkdir protoc
RUN cd $path/protoc && wget https://github.com/protocolbuffers/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip
RUN cd $path/protoc && unzip protoc-3.0.0-linux-x86_64.zip
RUN cp -r $path/protoc $path/Github/models/research/
RUN cd $path/Github/models/research && ./protoc/bin/protoc $path/Github/models/research/object_detection/protos/*.proto --proto_path=$path/Github/models/research/ --python_out=.

ENV PYTHONPATH $path/models/research:$path/models/research/slim

EXPOSE 8888