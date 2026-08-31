import 'package:flutter/foundation.dart';

class Logger {
  static void log(
    String data, {
    String? code,
    String? title,
    bool? error,
    bool? extraDetails,
  }) {
    if (kDebugMode) {
      print(
        (extraDetails ?? false)
            ? "${(error ?? false)
                  ? "🔴"
                  : code != "200"
                  ? "🟡"
                  : "🟢"} ${code ?? ""} ${title ?? ""}  ${DateTime.now().toIso8601String()}${data == "" ? "" : "\n"}$data"
            : "${(error ?? false)
                  ? "🔴"
                  : code != "200"
                  ? "🟡"
                  : "🟢"} $data",
      );
    }
  }
}
