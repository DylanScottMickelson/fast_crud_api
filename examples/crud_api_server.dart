import 'package:fast_crud_api/fast_crud_api.dart';
import 'package:shelf/shelf.dart';

void main() async {
  /// Define your create, read, update, and delete functions here...
  Future<Response> createFunction(Request request) async {
    return Response.ok("Created!");
  }

  Future<Response> readFunction(Request request) async {
    return Response.ok("Read!");
  }

  Future<Response> updateFunction(Request request) async {
    return Response.ok("Updated!");
  }

  Future<Response> deleteFunction(Request request) async {
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

  await apiServer.start();
}
