# Stage 1 lambda insight extensions
FROM public.ecr.aws/serverless/extensions/lambda-insights:12 AS lambda-insights

# Stage 2
FROM python:3.9.1-slim-buster AS build-image
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install ffmpeg libsm6 libxext6  -y
COPY --from=lambda-insights /opt /opt
RUN mkdir -p /app
WORKDIR /app
COPY requirements.txt ./
RUN python -m pip install -r requirements.txt -t .
RUN python -m pip install awslambdaric --target .
COPY app.py coco.names ./

# 로컬 테스트를 위한 AWS Lambda Runtime Interface Emulator 추가
ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD [ "app.lambda_handler" ]
