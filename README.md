<p align="center">
  <img src="fast_crud_api-banner-minimal.svg" alt="Fast CRUD API banner" />
</p>

A lightweight, customizable, easy-to-use package to create simple CRUD (Create, Read, Update, Delete) APIs. It uses the `shelf` package for building web servers and supports both default CRUD endpoints and custom routes.

## 📃 Features

* Default simple 4-endpoint CRUD API server
* Customizable with custom endpoints or a combination of both
* Supports HTTP methods: GET, POST, PUT, and DELETE
* CORS (Cross-Origin Resource Sharing) middleware enabled by default (Must be changed for Production!)
* Logging for debugging purposes

## 📖 Table of Contents

1. [Getting Started](#getting-started)
2. [Installation](#installation)
3. [Usage](#usage)
   * Creating a new API server
   * Customizing your API
   * Access your API
4. [Examples](#examples)
5. [Contributing](#contributing)
6. [License](#license)
7. [Contact](#contact)

## 🟢 Getting Started <a name="getting-started"></a>

To get started with `fast_crud_api`, make sure you have either the Flutter SDK or the Dart SDK installed on your system. You can find the installation instructions for both in their respective official documentation:

* [Flutter](https://docs.flutter.dev/install)
* [Dart](https://dart.dev/get-dart)

## 💽 Installation <a name="installation"></a>

Add `fast_crud_api` and `shelf` dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  shelf: any
  fast_crud_api:
    git:
      url: https://github.com/DylanScottMickelson/fast_crud_api.git
```

Now, run `flutter pub get` or `dart pub get` in your terminal/command prompt to install the package and its dependencies.

## ⚙️ Usage <a name="usage"></a>

### 🖥️ Creating a new API server

To create a new instance of the `APIServer` class, you'll need to provide it with the following parameters:

* `create`, `read`, `update`, and `delete` functions for handling CRUD requests (optional) `Future<Response> handler(Request request)`
* Port number for the server (optional) `int port`
* Version number for your API (optional) `int version`
* Name your API  `String apiName`
* A list of custom routes (optional) `List<CustomRoute> endpoints`
* Whether to enable logging or not (optional) `bool logger`
* Whether or not using CRUD. `bool noCRUD`

Here's an example:

```dart
import 'package:fast_crud_api/logger.dart';
import 'package:shelf/shelf.dart';

void main() async {

  /// Define your create, read, update, and delete functions here...
  Future<Response> createFunction(Request request) {
    return Response.ok("Created!");
  }

  Future<Response> readFunction(Request request) {
    return Response.ok("Read!");
  }

  Future<Response> updateFunction(Request request) {
    return Response.ok("Updated!");
  }

  Future<Response> deleteFunction(Request request) {
    return Response.ok("Deleted!");
  }

  final apiServer = APIServer(
    create: (request) => createFunction(request),
    read: (request) => readFunction(request),
    update: (request) => updateFunction(request),
    delete: (request) => deleteFunction(request),
    port: 6969,
    version: 1,
    apiName: "My API",
    noCRUD: false,
    logger: true,
  );

  await apiServer.startServer();
}
```

### ✏️ Customizing your API

To customize your API, you can define custom routes and their corresponding handlers as `CustomRoute` objects. These custom routes will be added to the main server in addition to the default CRUD endpoints if enabled.

Here's an example:

```dart
import 'package:fast_crud_api/custom_route.dart';
import 'package:fast_crud_api/logger.dart';
import 'package:shelf/shelf.dart';

void main() async {
  final handler = Response.notFound;

  /// Define your custom endpoints here...
  final customRoute1 = CustomRoute(
    endpoint: "users",
    method: "GET",
    handler: (request) => getUsersFunction(request),
  );

  final customRoute2 = CustomRoute(
    endpoint: "items/{itemId}",
    method: "GET",
    handler: (request) => getItemFunction(request),
  );

  final apiServer = APIServer(
    port: 6969,
    version: 1,
    apiName: "My API",
    noCRUD: true,
    logger: true,
    routes: [customRoute1, customRoute2],
  );

  await apiServer.startServer();
}
```

### 👨‍💻 Access Docs UI:

Production:
Go to http://ip_address:chosen_port/api/docs/

Test:
Go to http://127.0.0.1:6969/api/docs/

### 🧑‍💻 Access the CRUD endpoints by sending an HTTP request to:

Production:
- http://ip_address:chosen_port/v{version_number}/create 
- http://ip_address:chosen_port/v{version_number}/read
- http://ip_address:chosen_port/v{version_number}/update 
- http://ip_address:chosen_port/v{version_number}/delete 

Test:
- http://127.0.0.1:6969/v1/create
- http://127.0.0.1:6969/v1/read
- http://127.0.0.1:6969/v1/update
- http://127.0.0.1:6969/v1/delete

### 💻 Access Custom endpoints by sending an HTTP request to: 

Production: 
- http://ip_address:chosen_port/v{version_number}/your/custom/route

Test:
- http://127.0.0.1:6969/v1/your/custom/route

## 📑 Examples <a name="examples"></a>

You can find examples of using `fast_crud_api` in the `example` folder within this repository. These examples demonstrate creating a simple CRUD API, as well as adding custom routes.

## 🤗 Contributing <a name="contributing"></a>

Contributions are welcome! If you'd like to contribute, please take a look at our [CONTRIBUTING.md](./CONTRIBUTING.md) file for guidelines and instructions on reporting bugs or submitting pull requests.

## 🪪 License <a name="license"></a>

`fast_crud_api` is licensed under the MIT license. See the [LICENSE](./LICENSE) file for more information.

## 📧 Contact <a name="contact"></a>

If you have any questions, feel free to contact the creator at dylan.mickelson@free-os.org or open an issue on GitHub.
