# Global arguments
ARG FUNCTION_DIR="/home/app/"

# Stage 1 base image
FROM python:3.9.1-slim-buster AS base

# Stage 2 lambda insight extensions
FROM public.ecr.aws/serverless/extensions:lambda-insights-12 AS extension

# Stage 2
FROM base AS custom-build-image
ARG FUNCTION_DIR
RUN apt-get -y update \
&& apt-get -y upgrade \
&& apt-get clean
RUN mkdir -p ${FUNCTION_DIR}
COPY app.py requirements.txt ${FUNCTION_DIR}
RUN python -m pip install -r ${FUNCTION_DIR}/requirements.txt --target ${FUNCTION_DIR}
RUN python -m pip install awslambdaric --target ${FUNCTION_DIR}

# Stage 3
FROM base
ARG FUNCTION_DIR
WORKDIR /opt
COPY --from=extension /opt .

# WORKDIR ${FUNCTION_DIR}
# COPY --from=custom-build-image ${FUNCTION_DIR} ${FUNCTION_DIR}
# ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie
# RUN chmod 755 /usr/bin/aws-lambda-rie
# COPY entry.sh /
# RUN chmod +x /entry.sh
# ENTRYPOINT [ "/entry.sh" ]
# CMD [ "app.lambda_handler" ]

WORKDIR ${FUNCTION_DIR}
COPY --from=custom-build-image ${FUNCTION_DIR} ${FUNCTION_DIR}
ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD [ "app.lambda_handler" ]

# docker build -f small.Dockerfile -t lambda-customimagev2 .
# docker run -v ~/.aws-lambda-rie:/aws-lambda -p 9000:8080 --entrypoint /aws-lambda/aws-lambda-rie lambda-customimagev2:latest /usr/local/bin/python -m awslambdaric  app.lambda_handler
# curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'