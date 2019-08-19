# Peps mobile app

Frontend mobile application for peps based on Flutter.

## Setup the development environment

### Install Flutter

Ensure you have Flutter up and running by following [these steps](https://flutter.dev/docs/get-started/install).

### Create .env file

Create a ```.env``` file in the root of the project. This file should have the following environment vars:

```
API_KEY='your backend api key'
BACKEND_URL='the root URL and port of the API server'
```

Note that if you are running Peps backend localy and using an Android simulator, the ```BACKEND_URL``` env variable must be set at ```10.0.2.2:8000``` (assuming you started the server with ```python manage.py runserver 0.0.0.0:8000```).
