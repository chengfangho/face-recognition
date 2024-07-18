# **Face Recognition Project**

This project enables face recognition using AWS services, including Rekognition, S3, DynamoDB, and API Gateway, with a React frontend for user interaction. Follow the steps below to set up and run the project.

## Setup Instructions

### 1. Initialize Terraform

Navigate to the terraform folder and run the following command to initialize Terraform:

```terraform init```

### 2. Deploy Resources

Run the deploy.sh script from the project root directory to package the Lambda function and upload it to S3:

```./deploy.sh```

*Note: The first upload attempt will fail because the S3 bucket hasn't been created yet. The deploy.sh script includes running terraform apply, which will create the necessary resources.*

### 3. Update API Gateway URL
After the deploy.sh script finishes running, it will output the API Gateway invoke URL. Replace the ```invoke_url``` variable in **app/src/app.js** with this URL.

### 4. Upload Faces to S3
A bucket named ***face-registration-bucket-715*** will be created in S3. Upload face images with filenames in the format firstname_lastname.jpg or .png to this bucket. This will trigger AWS Rekognition to learn the faces and store their rekognition_id in DynamoDB for face-name mapping.

### 5. Start the React App
Navigate to the app folder and start the React app:
```
cd app
npm start
```

### 6. Use the Web Application
Store the face pictures you are using in **app/src/people**. Go to the web page and upload the pictures from the people folder. Click on **Check** to see if there's a match in the database. If a match is found, the name will be displayed; otherwise, it will show "Person is not in the system."
