# Peps mobile app

Frontend mobile application for peps based on Flutter.

🖥️ The repository for Peps' backend/API [can be found here](https://github.com/betagouv/peps).

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

### Add google-services.json for Firebase Crashlytics and Analytics

In order to setup Firebase (Crashlytics and Analytics), make sure you have downloaded the ```google-services.json``` from Firebase and placed it under ```/android/app/google-services.json```. Otherwise you will get this error:

```
A problem was found with the configuration of task ':app:processDebugGoogleServices'.
> File './android/app/google-services.json' specified for property 'quickstartFile' does not exist.
```

## Widget testing

Widget test files are found in the ```test``` directory. To run widget tests, type in the console:

```
fluter test test
```

You should see an output that ends with:

```
...
00:02 +1: All tests passed!
```

Alternatively, if you are using VSCode, there is a ```launch.json``` entry that allows you to run the tests directly from the editor's debug tab ("Test Widget"). This will allow you to breakpoint in the code.

## Integration testing

Integration test files are found in the ```test_driver``` directory. To run integration tests, type in the console:

```
flutter drive --target=test_driver/app.dart
```

You should see an output that ends with:

```
...
00:02 +4: All tests passed!
Stopping application instance.
```
