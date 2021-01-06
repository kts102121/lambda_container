FROM public.ecr.aws/lambda/python:3.8
COPY app.py requirements.txt ./
COPY dog.jpg ./
RUN python -m pip install -r requirements.txt -t .
CMD ["app.lambda_handler"]

# docker build -t myfunction . --build-arg AWS_DEFAULT_REGION=us-east-1 --build-arg AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_LAMBDA_LAYER} --build-arg AWS_SECRET_ACCESS_KEY=${AWS_SECRET_KEY_LAMBDA_LAYER} && docker run -p 9000:8080 myfunction:latest
# aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 618970304109.dkr.ecr.us-east-1.amazonaws.com
# docker tag myfunction:latest 618970304109.dkr.ecr.us-east-1.amazonaws.com/myfunction:latest
# docker push 618970304109.dkr.ecr.us-east-1.amazonaws.com/myfunction:latest
# curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'