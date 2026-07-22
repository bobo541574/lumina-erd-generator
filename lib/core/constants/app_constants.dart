class AppConstants {
  AppConstants._();

  static const String appName = 'Laravel ERD Generator';
  static const String appVersion = '1.0.0';

  static const List<String> laravelIndicatorFiles = [
    'artisan',
  ];

  static const List<String> laravelIndicatorDirectories = [
    'app/Models',
    'database/migrations',
  ];

  static const List<String> supportedPhpFileExtensions = ['.php'];

  static const int maxRecentProjects = 5;

  static const double minZoom = 0.25;
  static const double maxZoom = 3.0;
  static const double defaultZoom = 1.0;

  static const double defaultNodeWidth = 220.0;
  static const double defaultNodeMinHeight = 120.0;
  static const double defaultNodeMaxHeight = 400.0;
}
