import json
import os
import cv2
import numpy as np
import boto3
import base64
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.core import patch_all

patch_all()

SAGEMAKER_ENDPOINT = os.environ['SAGEMAKER_ENDPOINT_NAME']
runtime = boto3.client('runtime.sagemaker')

classes = []
with open("coco.names", "r") as f:
    classes = [line.strip() for line in f.readlines()]

# Create random RGB array with number of classes
colors = np.random.uniform(0, 255, size=(len(classes), 3))

def load_image_from_base64(img_string):
    # Decode the base64 string into an image
    base_img = base64.b64decode(img_string)
    npimg = np.fromstring(base_img, dtype=np.uint8)
    img = cv2.imdecode(npimg, 1)

    # fetch image height and width
    height, width = img.shape[:2]

    return img, height, width
    
def draw_boxes(img, boxes, confidences, class_ids, indexes, colors, classes):    
    for i in range(len(boxes)):
        if i in indexes:
            b_x, b_y, b_w, b_h = boxes[i]
            label = f"{classes[class_ids[i]]} {confidences[i]:.2f}"
            color = colors[i]
            cv2.rectangle(img, (b_x, b_y), (b_w, b_h), color, 2)
            cv2.putText(img, label, (b_x, b_y + 30), cv2.FONT_HERSHEY_PLAIN, 3, color, 3)

    return img

def resize_box(bbox, in_size, out_size):
    bbox = bbox.copy().astype(float)
    
    x_scale = out_size[0] / in_size[0]
    y_scale = out_size[1] / in_size[1]
    
    bbox[:, 1] = y_scale * bbox[:, 1]
    bbox[:, 3] = y_scale * bbox[:, 3]
    bbox[:, 0] = x_scale * bbox[:, 0]
    bbox[:, 2] = x_scale * bbox[:, 2]
    
    bbox = np.array(bbox, dtype=np.int).tolist()
    return bbox

def lambda_handler(event, context):
    image_string = json.loads(event.get('body'))
    orig_img, height, width = load_image_from_base64(image_string['image'])

    response = runtime.invoke_endpoint(EndpointName=SAGEMAKER_ENDPOINT,
                                        ContentType='application/json',
                                        Body=json.dumps(image_string))

    outputs = response["Body"].read().decode("utf-8")
    outputs = json.loads(outputs)
    shape = outputs['shape']
    class_ids = np.array(outputs['class_ids'], dtype=np.int).squeeze().tolist()
    confidences = np.array(outputs['confidences']).squeeze().tolist()
    boxes = np.array(outputs['boxes'])
    boxes = resize_box(boxes, (shape[2], shape[3]), (orig_img.shape[0], orig_img.shape[1]))
    indexes = cv2.dnn.NMSBoxes(boxes, confidences, 0.5, 0.3)
    
    img = draw_boxes(orig_img, boxes, confidences, class_ids, indexes, colors, classes)
    _, buffered_img = cv2.imencode('.jpg', img)
    image_string = base64.b64encode(buffered_img).decode('utf8')
    payload = {'body': image_string}

    return {
        'statusCode': 200,
        'body': json.dumps(payload),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }