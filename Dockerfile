FROM public.ecr.aws/lambda/python:3.8
COPY requirements.txt dog.jpg ./
RUN python -m pip install -r requirements.txt -t .
COPY app.py ./
CMD ["app.lambda_handler"]