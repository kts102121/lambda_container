FROM public.ecr.aws/lambda/python:3.8
COPY app.py requirements.txt dog.jpg ./
RUN python -m pip install -r requirements.txt -t .
CMD ["app.lambda_handler"]