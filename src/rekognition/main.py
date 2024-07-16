import boto3

s3 = boto3.client("s3")
rekognition = boto3.client("rekognition", region_name="us-west-2")
dynamodb = boto3.resource("dynamodb", region_name="us-west-2")
dynamodb_table_name = "faces-715"
employee_table = dynamodb.Table(dynamodb_table_name)


def lambda_handler(event, context):
    print(event)
    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = event["Records"][0]["s3"]["object"]["key"]
    try:
        response = index_face_image(bucket, key)
        print(response)
        if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
            face_id = response["FaceRecords"][0]["Face"]["FaceId"]
            name = key.split(".")[0].split("_")
            first_name = name[0]
            last_name = name[1]
            register_face(face_id, first_name, last_name)
        return response
    except Exception as e:
        print(e)
        print(f"Error processing image {key} from bucket {bucket}")
        raise (e)


def index_face_image(bucket, key):
    response = rekognition.index_faces(
        Image={"S3Object": {"Bucket": bucket, "Name": key}}, CollectionId="faces-715"
    )
    return response


def register_face(face_id, first_name, last_name):
    employee_table.put_item(
        Item={
            "rekognition_id": face_id,
            "first_name": first_name,
            "last_name": last_name,
        }
    )
