# Stage 1 기본이미지 + 종속성 설치
FROM python:3.9.1-slim-buster AS custom-build-image
RUN mkdir -p /app
WORKDIR /app
COPY app.py requirements.txt dog.jpg /app/
RUN python -m pip install -r requirements.txt --target .
# Install aws lambda python runtime interface clients
RUN python -m pip install awslambdaric --target .

# Stage 2 최종 이미지
FROM python:3.9.1-slim-buster
WORKDIR /app
# 최종 이미지에 State 1에서 빌드된 종속성 결과물 추가하기
COPY --from=custom-build-image /app /app
ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD [ "app.lambda_handler" ]