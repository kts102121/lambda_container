ARG FUNCTION_DIR="/app/"

# Stage 1 lambda insight extensions
FROM public.ecr.aws/serverless/extensions/lambda-insights:12 AS lambda-insights

# Stage 2 기본이미지 + 종속성 설치
FROM python:3.9.1-slim-buster AS custom-build-image
ARG FUNCTION_DIR
RUN mkdir -p ${FUNCTION_DIR}
COPY app.py requirements.txt dog.jpg ${FUNCTION_DIR}
RUN python -m pip install -r ${FUNCTION_DIR}/requirements.txt --target ${FUNCTION_DIR}
# Install aws lambda python runtime interface clients
RUN python -m pip install awslambdaric --target ${FUNCTION_DIR}

# Stage 3
FROM python:3.9.1-slim-buster
ARG FUNCTION_DIR
WORKDIR ${FUNCTION_DIR}
COPY --from=custom-build-image ${FUNCTION_DIR} ${FUNCTION_DIR}
COPY --from=lambda-insights /opt /opt
ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD [ "app.lambda_handler" ]