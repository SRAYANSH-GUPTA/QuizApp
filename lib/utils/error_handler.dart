class NetworkError implements Exception {
  final String message;
  NetworkError(this.message);
}

class ServerError implements Exception {
  final String message;
  final int? statusCode;
  ServerError(this.message, {this.statusCode});
}

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is NetworkError) {
      return 'No internet connection. Please check your connection and try again.';
    } else if (error is ServerError) {
      return 'Server error: ${error.message}. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
