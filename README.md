# Flutter Pakistan App
Flutter Live Extended is organized by Flutter Pakistan community in Karachi and it is based on Flutter Live event. 

This project is the Flutter app for the event. Feel free to fork this repo to customize the app for your own event.

## Inspiration
The app takes a lot from [Google I/O Android app](https://github.com/google/iosched) while trimming down the stuff that was not needed. It also adds a few features as described in next section.

# Features
The app displays a list of sessions with an option to see the details about sessions and speakers. Users can also register for the event using the app and at event day, it lets users mark their attendance using QR code. The app uses Google Sign-in to fetch user details and to enable event registration through the app.

The app also displays a map of the venue with an option to navigate using the installed maps app. 

# Development Environment
The app is written entirely in Flutter and should compile and run on stable Flutter versions (tested till 1.2). 

## Firebase
The app makes considerable use of following Firebase components:
* [Cloud Firestore](https://firebase.google.com/docs/firestore/) is the source of all data being shown on the app including session and speaker details, and user registration.
* [Firebase Authentication](https://firebase.google.com/docs/auth/) is used to let the user sign-in using their Google ID. 

### Setting up
This repo does not contain some required Firebase setup. Follow [this guide](https://firebase.google.com/docs/flutter/setup) to setup Cloud Firestore for this app. There's also a good [video walkthrough](https://www.youtube.com/watch?v=DqJ_KjFzL9I) for setting up. 

### Importing Firebase data
The app depends on an already setup Firestore data in order to run properly which is present in `/data/firebase-export.json`. To import this data, follow these steps:
1. Install [Firestore Import/Export utility](https://www.npmjs.com/package/node-firestore-import-export)
2. [Export your Firebase private key](https://www.npmjs.com/package/node-firestore-import-export#retrieving-google-cloud-account-credentials), it will be automatically downloaded to your computer. Copy this file to the `/data` folder. Rename this file to `firebase-credentials.json`.
3. Open terminal and go to `/data` folder. 
4. Run the following command
```
$ firestore-import -a firebase-credentials.json -b firebase-export.json
```
5. After this command is executed successfully, go to your Database section of your Firebase console to make sure that the data is created there.

### Exporting Firebase data
You can also export Firestore data using the following command:
```
$ firestore-export -a firebase-credentials.json -b firebase-export.json -p
```
This will export the data into `firebase-export.json` file. 

One common use case is to get all users and export them to CSV. There's a Dart script included in the `data` folder and it can be used as shown below:
```
$ dart convert.dart firebase-export.json
```
This will create an `export.csv` in the same folder which you can then use with Microsoft Excel, Google Sheets etc.

# Getting started with Flutter
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

# Copyright

```
Copyright 2019 Flutter Pakistan. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```