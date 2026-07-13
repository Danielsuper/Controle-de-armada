// ignore_for_file: avoid_print

/// Logger simples para debug
class AppLogger {
  static const String _tag = '[CONTROLE_ARMADA]';

  /// Log de informação
  static void info(String message) {
    print('$_tag [INFO] $message');
  }

  /// Log de erro
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    print('$_tag [ERROR] $message');
    if (error != null) print('Error: $error');
    if (stackTrace != null) print('StackTrace: $stackTrace');
  }

  /// Log de warning
  static void warning(String message) {
    print('$_tag [WARNING] $message');
  }

  /// Log de debug
  static void debug(String message) {
    print('$_tag [DEBUG] $message');
  }
}
