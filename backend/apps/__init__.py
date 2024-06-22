# -*- coding: utf-8 -*-
"""
-------------------------------------------------
   File Name：     __init__.py
   Description :
   Author :       guxu
   date：          6/22/24
-------------------------------------------------
   Change Activity:
                   6/22/24:
-------------------------------------------------
"""

from flask import Flask
import os
from flask_cors import CORS

# create a Flask application
app = Flask(__name__)


# app.debug = True


CORS(app)


# creates an instance of SQLAlchemy and binds it to the Flask application.
# This allows you to define database models and interact with the database
# using SQLAlchemy.

import apps.router