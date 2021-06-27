class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    if (message.isNotEmpty)
      return message;
    else
      return '';
  }
}
