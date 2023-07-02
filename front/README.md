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
### ql_gen
To generate graphql api run
```bash
dart run ql_gen -s ../src/schema.gql
```

Please read the documentation in *ql_gen* the [README.md](../ql_gen/README.md) for more information.

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
