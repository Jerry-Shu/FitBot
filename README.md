# FitBot

## How to run the backend
1. Configure the aws credential
2. Change directory to `backend`
```shell
cd backend/
```
3. [OPTIONAL] Create a venv and activate it
```shell
virtualenv venv
source venv/bin/activate
```
4. install the dependencies
```shell
pip install -r requirements.txt
```
5. Start the flask server (make sure the 5656 port is not in use)
```shell
python -m runserver
```