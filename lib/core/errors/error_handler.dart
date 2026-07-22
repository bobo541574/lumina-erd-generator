import 'app_exceptions.dart';

class ErrorHandler {
  ErrorHandler._();

  static AppException handleError(dynamic error, StackTrace? stackTrace) {
    if (error is AppException) {
      return error;
    }

    final message = error.toString();

    if (message.contains('artisan') || message.contains('not a valid Laravel')) {
      return const InvalidLaravelProjectException();
    }

    if (message.contains('migration') || message.contains('Schema::')) {
      return MigrationParseException(
        message: 'Failed to parse migration file',
        originalError: error,
      );
    }

    if (message.contains('model') || message.contains('Model')) {
      return ModelParseException(
        message: 'Failed to parse model file',
        originalError: error,
      );
    }

    return AppException(
      message: 'An unexpected error occurred',
      suggestion: 'Please try again or report this issue.',
      originalError: error,
    );
  }

  static String userFriendlyMessage(AppException error) {
    final buffer = StringBuffer(error.message);
    if (error.suggestion != null) {
      buffer.write('\n\nSuggestion: ${error.suggestion}');
    }
    return buffer.toString();
  }

  static bool isRecoverable(AppException error) {
    return error is! InvalidLaravelProjectException;
  }
}
