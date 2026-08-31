class CustomRoute {
  final String endpoint;
  final String method;
  final Function handler;

  CustomRoute({
    required this.endpoint,
    required this.method,
    required this.handler,
  });

  Map toMap() {
    return {"endpoint": endpoint, "method": method, "handler": handler};
  }

  static CustomRoute fromMap(Map data) {
    return CustomRoute(
      endpoint: data["endpoint"],
      method: data["method"],
      handler: data["handler"],
    );
  }
}
