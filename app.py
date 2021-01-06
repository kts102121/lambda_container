import base64
import io
from PIL import Image

def lambda_handler(event, context):
    with open('./dog.jpg', 'rb') as image:
        image_string = base64.b64encode(image.read())
    
        return {
            'isBase64Encoded': True,
            'statusCode': 200,
            'headers': {'Content-Type': 'image/jpg'},
            'body': image_string
        }