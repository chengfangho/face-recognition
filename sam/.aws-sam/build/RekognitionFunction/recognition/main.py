import boto3
import json

s3 = boto3.client('s3')
rekognition = boto3.client('rekognition', region_name='us-west-2')
dynamodb = boto3.resource('dynamodb', region_name='us-west-2')
dynamodb_table_name = 'faces-715'
face_table = dynamodb.Table(dynamodb_table_name)
bucket_name = 'face-recognition-bucket-715'

def lambda_handler(event, context):
    print(event)
    object_key = event['queryStringParameters']['objectKey']
    image_bytes = s3.get_object(Bucket=bucket_name, Key=object_key)['Body'].read()
    response = rekognition.search_faces_by_image(
        CollectionId = 'faces-715',
        Image = {
            'Bytes':image_bytes
        }
    )
    for match in response['FaceMatches']:
        print(match['Face']['FaceId'], match['Face']['Confidence'])
        face = face_table.get_item(
            Key={
                'rekognition_id':match['Face']['FaceId']
            }
        )
        if 'Item' in face:
            print(f"Person found: {face['Item']}")
            return buildResponse(200, {
                'message': 'Success',
                'first_name':face['Item']['first_name'],
                'last_name':face['Item']['last_name']
            })
    print('Person could not be recognized')
    return buildResponse(403, {'Message':"Person not found"})

def buildResponse(statusCode, body=None):
    response = {
        'statusCode':statusCode,
        'headers':{
            'Content_Type':'application/json',
            'Access-Control-Allow-Origin':'*'
        }
    }
    if body is not None:
        response['body'] = json.dumps(body)
    return response