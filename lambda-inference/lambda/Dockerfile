FROM python:3.9.1-slim-buster

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install ffmpeg libsm6 libxext6  -y
RUN mkdir -p /app
WORKDIR /app

COPY requirements.txt ./
RUN python -m pip install -r requirements.txt -t .
RUN python -m pip install awslambdaric --target .

COPY yolov3.cfg yolov3.weights coco.names dog.jpg  ./

COPY app.py ./

# 로컬 테스트를 위한 AWS Lambda Runtime Interface Emulator 추가
ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD ["app.lambda_handler"]
