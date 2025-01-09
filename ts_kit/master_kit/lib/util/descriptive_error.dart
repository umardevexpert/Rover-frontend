class DescriptiveError extends Error {
  final String? message;
  final Object? cause;

  DescriptiveError({this.message, this.cause});

  @override
  String toString() {
    final errorMessage = message == null ? '' : '\n\nError message:\n$message';
    final reasonMessage = cause == null ? '' : '\n\nCause of this exception:\n$cause';

    return '$runtimeType ocurred'
        '$errorMessage'
        '$reasonMessage\n';
  }
}
