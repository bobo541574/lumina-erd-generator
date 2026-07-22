class AppException implements Exception {
  final String message;
  final String? suggestion;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.suggestion,
    this.originalError,
  });

  @override
  String toString() {
    final buffer = StringBuffer('AppException: $message');
    if (suggestion != null) buffer.write('\nSuggestion: $suggestion');
    return buffer.toString();
  }
}

class InvalidLaravelProjectException extends AppException {
  const InvalidLaravelProjectException({
    String message = 'The selected directory is not a valid Laravel project.',
    String? suggestion,
  }) : super(
         message: message,
         suggestion:
             suggestion ?? 'Ensure the directory contains an artisan file.',
       );
}

class MigrationParseException extends AppException {
  final String? filePath;

  const MigrationParseException({
    String message = 'Failed to parse migration file.',
    this.filePath,
    String? suggestion,
    dynamic originalError,
  }) : super(
         message: message,
         suggestion: suggestion,
         originalError: originalError,
       );
}

class ModelParseException extends AppException {
  final String? filePath;

  const ModelParseException({
    String message = 'Failed to parse model file.',
    this.filePath,
    String? suggestion,
    dynamic originalError,
  }) : super(
         message: message,
         suggestion: suggestion,
         originalError: originalError,
       );
}

class ExportException extends AppException {
  final String? format;

  const ExportException({
    String message = 'Failed to export schema.',
    this.format,
    String? suggestion,
    dynamic originalError,
  }) : super(
         message: message,
         suggestion: suggestion,
         originalError: originalError,
       );
}
