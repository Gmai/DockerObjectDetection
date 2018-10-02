FROM tensorflow/tensorflow:nightly-devel-gpu-py3

ARG path=/usr/src/object_detection

RUN pip3 install --upgrade tensorflow-gpu==1.9

RUN pip3 install Cython
RUN pip3 install contextlib2
RUN pip3 install image
RUN pip3 install 'prompt-toolkit==2.0.4'

RUN mkdir -p $path
WORKDIR $path

COPY Github $path

RUN cd cocoapi/PythonAPI && make
RUN cp -r cocoapi/PythonAPI/pycocotools models/research/

COPY /protoc/ models/research/
RUN cd models/research && ./bin/protoc object_detection/protos/*.proto --python_out=.

ENV PYTHONPATH $path/models/research:$path/models/research/slim

EXPOSE 8888