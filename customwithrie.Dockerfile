# Stage 1 기본이미지 + 종속성 설치
FROM python:3.9.1-slim-buster AS custom-build-image
RUN mkdir -p /app
WORKDIR /app
COPY app.py requirements.txt dog.jpg /app/
RUN python -m pip install -r requirements.txt --target .
RUN python -m pip install awslambdaric --target .

# Stage 2 최종 이미지
FROM python:3.9.1-slim-buster
WORKDIR /app
COPY --from=custom-build-image /app /app
# 로컬 테스트를 위한 AWS Lambda Runtime Interface Emulator 추가
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie
RUN chmod 755 /usr/bin/aws-lambda-rie
COPY entry_script.sh /
RUN chmod +x /entry_script.sh
ENTRYPOINT [ "/entry_script.sh" ]
CMD [ "app.lambda_handler" ]