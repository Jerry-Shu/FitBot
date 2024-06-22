# -*- coding: utf-8 -*-
"""
-------------------------------------------------
   File Name：     runserver
   Description :
   Author :       guxu
   date：          6/22/24
-------------------------------------------------
   Change Activity:
                   6/22/24:
-------------------------------------------------
"""

from apps import app

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=5656)