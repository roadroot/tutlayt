## Prerequisites

* Have flutter installed, please follow the instructions at https://docs.flutter.dev/get-started/install
* Have the services launched, please follow

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Setup
### Env file
Create a `.env` file respecting the template in `.env.template`. You can run this command to make a copy of template to the `.env` file: 
```bash
cp .env.template .env
```
### build_runner
To generate graphql files run 
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
To watch for changes and generate graphql files run 
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Cors
Consider installing  *flutter_cors* to enable or disable CORS.
* First install *flutter_cors* globally using : `dart pub global activate flutter_cors`
* Then add the flutter *.pub-chache* to the PATH environment variable
  * for windows: **%LOCALAPPDATA%\Pub\Cache\bin**
  * for linux/macOS: **~\\.pub-cache\bin** <!---TODO check the path is correct-->
* Run `flutter_cors --disable` to disable CORS
* Run `flutter_cors --enabke` to enable CORS

### l10n
To generate translations run `flutter gen-l10n`. 