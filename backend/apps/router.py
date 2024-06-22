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

@app.route('/')
def index():
    return "OK"
