class AppConstants {
  AppConstants._();

  static const String appName = 'Lumina ERD Studio';
  static const String appVersion = '1.0.0';

  static const List<String> laravelIndicatorFiles = ['artisan'];

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

  static const double nodeHeaderHeight = 44.0;
  static const double nodeRowHeight = 24.0;

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 32.0;

  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusFull = 999.0;

  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);
}
