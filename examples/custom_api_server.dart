import 'dart:convert';

import 'package:fast_crud_api/custom_route.dart';
import 'package:fast_crud_api/fast_crud_api.dart';
import 'package:shelf/shelf.dart';

void main() async {
  /// Define your custom endpoints here...
  final customRoute1 = CustomRoute(
    endpoint: "users",
    method: "GET",
    handler: (request) => Response.ok(jsonEncode({"users": []})),
  );

  final apiServer = APIServer(
    port: 6969,
    version: 1,
    apiName: "My API",
    noCRUD: true,
    logger: true,
    routes: [customRoute1],
  );

  await apiServer.start();
}
