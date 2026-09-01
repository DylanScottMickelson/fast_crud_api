import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:fast_crud_api/custom_route.dart';
import 'package:fast_crud_api/logger.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:path/path.dart' as p;

/// FAST CRUD API SERVER
///
/// Creates a simple 4 endpoint CRUD API server,
/// a custom API server with custom endpoints,
/// or a combination of both.
///
/// Creator: Dylan Scott Mickelson
/// Date: 3/24/2026
/// Edited:
/// 7/24/2026 DSM
/// 8/03/2026 DSM
/// 8/10/2026 DSM

class APIServer {
  final String? apiName;
  final Future<Response> Function(Request)? create;
  final Future<Response> Function(Request)? read;
  final Future<Response> Function(Request)? update;
  final Future<Response> Function(Request)? delete;
  final int? port;
  final int? version;
  final List<CustomRoute>? routes;
  final bool? noCRUD;
  final bool? logger;

  APIServer({
    this.create,
    this.read,
    this.update,
    this.delete,
    this.port,
    this.version,
    this.apiName,
    this.routes,
    this.noCRUD,
    this.logger,
  });

  ///Custom Logger : Middleware Function
  Middleware customLogger() {
    return logRequests(
      logger: (message, isError) {
        if (logger ?? false) {
          List<String> splitList = message.split(" ");
          String code = splitList.length < 9
              ? ""
              : splitList[8].replaceAll("[", "").replaceAll("]", "");
          Logger.log(message, code: code, error: isError);
        }
      },
    );
  }

  ///CORS Middleware : Middleware Function
  Middleware createCorsMiddleware() {
    // Define your allowed headers
    final corsHeaders = {
      'Access-Control-Allow-Origin':
          '*', // Change to your specific domain for production
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers':
          'Origin, Content-Type, Authorization, X-Requested-With',
    };

    return (Handler innerHandler) {
      return (Request request) async {
        // 1. Handle browser preflight OPTIONS requests immediately
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: corsHeaders);
        }

        // 2. Process all other requests through your normal router
        final response = await innerHandler(request);

        // 3. Append CORS headers to the final response
        return response.change(headers: {...response.headers, ...corsHeaders});
      };
    };
  }

  ///Start Sever : Void Function
  Future<void> start() async {
  final Router app = Router();

   Future<String> getPackageLibPath() async {
  final uri = await Isolate.resolvePackageUri(
    Uri.parse('package:fast_crud_api/fast_crud_api.dart'),
  );
  return p.dirname(uri!.toFilePath());
}

// Then:
final webDir = p.join(await getPackageLibPath(), 'assets', 'web');

    ///FAST CRUD DOCS UI Handler
    final flutterWebHandler = createStaticHandler(
      webDir,
      defaultDocument: 'index.html',
    );

    final InternetAddress address = InternetAddress.anyIPv4;

    List endpoints = List.empty(growable: true);

    if ((noCRUD ?? false) == false) {
      endpoints = List.from([
        {"endpoint": "/v${version ?? 1}/create", "method": "POST"},
        {"endpoint": "/v${version ?? 1}/read", "method": "GET"},
        {"endpoint": "/v${version ?? 1}/update", "method": "PUT"},
        {"endpoint": "/v${version ?? 1}/delete", "method": "DELETE"},
      ], growable: true);
    }

    app.get("/", flutterWebHandler);

    app.get('/api/version', (Request request) async {
      return Response.ok(jsonEncode({"version": version ?? 1}));
    });

    app.get('/api/name', (Request request) async {
      return Response.ok(jsonEncode({"name": apiName ?? "FAST CRUD API"}));
    });

    app.get('/api/endpoints', (Request request) async {
      return Response.ok(jsonEncode({"points": endpoints}));
    });

    ///Add DEFUALT CRUD Endpoints
    if ((noCRUD ?? false) == false &&
        create != null &&
        read != null &&
        update != null &&
        delete != null) {
      ///Create Handler
      app.post('/v${version ?? 1}/create', (Request request) async {
        return await create!(request);
      });

      ///Read Handler
      app.get('/v${version ?? 1}/read', (Request request) async {
        return await read!(request);
      });

      ///Update Handler
      app.put('/v${version ?? 1}/update', (Request request) async {
        return await update!(request);
      });

      ///Delete Handler
      app.delete('/v${version ?? 1}/delete', (Request request) async {
        return await delete!(request);
      });
    }

    ///Add Custom Routes
    if (routes?.isNotEmpty ?? false) {
      for (CustomRoute route in routes!) {
        final String endpoint = "/v${version ?? 1}/${route.endpoint}";
        Future<Response> handler(Request request) async {
          Response response = await route.handler(request);
          return response;
        }

        switch (route.method) {
          case "GET":
            {
              app.get(endpoint, handler);
            }
            break;
          case "POST":
            {
              app.post(endpoint, handler);
            }
            break;
          case "PUT":
            {
              app.put(endpoint, handler);
            }
            break;
          case "DELETE":
            {
              app.delete(endpoint, handler);
            }
            break;
          default:
            Logger.log("🚩 Route method not supported: ${route.method}");
            break;
        }

        endpoints.add({"endpoint": endpoint, "method": route.method});
        Logger.log("$endpoint ✅ Custom endpoint added!", code: "200");
      }
    }

    ///Create API Pipeline Handler
    final handler = const Pipeline()
        .addMiddleware(customLogger())
        .addMiddleware(createCorsMiddleware())
        .addHandler(app.call);

    ///Create & Start HTTP Server
    final HttpServer server = await serve(handler, address, 6969);

    ///Log Server Start Success
    Logger.log(
      '✅ $apiName Server started on port ${server.port}\n🌐 Access Production API docs at http://${address.address}:${server.port}/\n🧑‍💻 Dev API docs at http://localhost:${server.port}/',
      code: "200",
    );
  }
}
