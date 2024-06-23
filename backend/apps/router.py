# -*- coding: utf-8 -*-
"""
-------------------------------------------------
   File Name：     router
   Description :
   Author :       guxu
   date：          6/22/24
-------------------------------------------------
   Change Activity:
                   6/22/24:
-------------------------------------------------
"""
from apps import app
from apps.services.file_upload_service import FileUploadService
from apps.services.fitness_service import FitnessService
from flask import request, jsonify

file_upload_service = FileUploadService()
fitness_service = FitnessService()

@app.route('/')
def index():
    return "OK"

@app.route('/api/upload', methods=['POST'])
def upload():
    img = request.files["file"]
    response = file_upload_service.upload_img(img)
    return jsonify(response)

@app.route('/api/evaluate', methods=['POST'])
def evaluate():
    data = request.get_json()
    print("data", data)
    url = data["url"]
    response = fitness_service.get_feedback(url)
    return jsonify(response)