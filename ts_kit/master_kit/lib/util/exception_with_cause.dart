class ExceptionWithCause implements Exception {
  final String? message;
  final Object? cause;

  /// cause should be either Error or exception
  ExceptionWithCause({this.message, this.cause});

  @override
  String toString() {
    final errorMessage = message == null ? '' : '\n\nError message:\n$message';
    final reasonMessage = cause == null ? '' : '\n\nCause of this error:\n$cause';

    return '$runtimeType has been thrown'
        '$errorMessage'
        '$reasonMessage\n';
  }
}
