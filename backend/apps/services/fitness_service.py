# -*- coding: utf-8 -*-
"""
-------------------------------------------------
   File Name：     fitness_service
   Description :
   Author :       guxu
   date：          6/22/24
-------------------------------------------------
   Change Activity:
                   6/22/24:
-------------------------------------------------
"""
import os.path

import boto3
from botocore.exceptions import ClientError
from apps.utils.util import image_to_base64, video_to_gif, make_gif_path
import json
from apps.enums.response_status import ResponseStatus
from apps.constants import LOCAL_UPLOAD_DIRECTORY
class FitnessService:
    def __init__(self):
        # Create a Bedrock Runtime client in the AWS Region of your choice.
        self.client = boto3.client("bedrock-runtime", region_name="us-east-1")
        self.model_id = "anthropic.claude-3-5-sonnet-20240620-v1:0"
        self.response_format = {
            "rating": 80,
            "overall_evaluation": ["point1", "point2", "..."],
            "potential_improvement": [
                {"problem": "p1", "improvement": "i1"},
                {"problem": "p2", "improvement": "i2"},
                "..."
            ]
        }

    def get_feedback(self, input_path):
        input_path = os.path.join(LOCAL_UPLOAD_DIRECTORY, input_path)
        print("input_path: ", input_path)
        gif_url = make_gif_path(input_path)
        print("gif_path", gif_url)
        video_to_gif(input_path, gif_url)
        base64_img = image_to_base64(gif_url)
        native_request = {
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": 1024,
            "temperature": 0.5,
            "system": "You are a senior fitness instructor, master the essentials of all fitness movements, and are very good at helping students correct wrong fitness movements.",
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "image",
                            "source": {
                                "type": "base64",
                                "media_type": 'image/gif',
                                "data": base64_img,
                            },
                        },
                        {
                            "type": "text",
                            "text": f"Evaluate the fitness movement, give a rating of the movement out of 100 and give an overall evaluation and point out the problem of this movement and how to improve, you answer must be a json in this format: {self.response_format}"
                        }
                    ],
                }
            ],
        }
        # Convert the native request to JSON.
        request = json.dumps(native_request)

        resp = {}
        try:
            # Invoke the model with the request.
            response = self.client.invoke_model(modelId=self.model_id, body=request)
            model_response = json.loads(response["body"].read())
            response_text = model_response["content"][0]["text"]
            resp.update(FitnessResponse.SUCCESS)
            resp.update({"data": json.loads(response_text)})
            print(resp)
        except (ClientError, Exception) as e:
            print(f"ERROR: Can't invoke '{self.model_id}'. Reason: {e}")
            resp.update(FitnessResponse.FAIL)
        return resp

class FitnessResponse(ResponseStatus):
    pass