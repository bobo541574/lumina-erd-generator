import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  final bool enableModelParsing;
  final bool strictMode;
  final bool includeSoftDeletes;
  final List<String> ignoredTables;
  final String defaultLayout;
  final String colorScheme;
  final String lineStyle;
  final String notationStyle;
  final String defaultExportFormat;
  final bool autoIncludeDataDict;
  final String fileNamingPattern;
  final String outputDirectory;

  const AppConfig({
    this.enableModelParsing = true,
    this.strictMode = false,
    this.includeSoftDeletes = true,
    this.ignoredTables = const [],
    this.defaultLayout = 'grid',
    this.colorScheme = 'light',
    this.lineStyle = 'curved',
    this.notationStyle = 'crowsFoot',
    this.defaultExportFormat = 'mermaid',
    this.autoIncludeDataDict = true,
    this.fileNamingPattern = '{project}_erd',
    this.outputDirectory = '',
  });

  AppConfig copyWith({
    bool? enableModelParsing,
    bool? strictMode,
    bool? includeSoftDeletes,
    List<String>? ignoredTables,
    String? defaultLayout,
    String? colorScheme,
    String? lineStyle,
    String? notationStyle,
    String? defaultExportFormat,
    bool? autoIncludeDataDict,
    String? fileNamingPattern,
    String? outputDirectory,
  }) {
    return AppConfig(
      enableModelParsing: enableModelParsing ?? this.enableModelParsing,
      strictMode: strictMode ?? this.strictMode,
      includeSoftDeletes: includeSoftDeletes ?? this.includeSoftDeletes,
      ignoredTables: ignoredTables ?? this.ignoredTables,
      defaultLayout: defaultLayout ?? this.defaultLayout,
      colorScheme: colorScheme ?? this.colorScheme,
      lineStyle: lineStyle ?? this.lineStyle,
      notationStyle: notationStyle ?? this.notationStyle,
      defaultExportFormat: defaultExportFormat ?? this.defaultExportFormat,
      autoIncludeDataDict: autoIncludeDataDict ?? this.autoIncludeDataDict,
      fileNamingPattern: fileNamingPattern ?? this.fileNamingPattern,
      outputDirectory: outputDirectory ?? this.outputDirectory,
    );
  }

  static const _defaults = AppConfig();

  static AppConfig defaults() => _defaults;
}

class ConfigService {
  static const _keyEnableModelParsing = 'enable_model_parsing';
  static const _keyStrictMode = 'strict_mode';
  static const _keyIncludeSoftDeletes = 'include_soft_deletes';
  static const _keyIgnoredTables = 'ignored_tables';
  static const _keyDefaultLayout = 'default_layout';
  static const _keyColorScheme = 'color_scheme';
  static const _keyLineStyle = 'line_style';
  static const _keyNotationStyle = 'notation_style';
  static const _keyDefaultExportFormat = 'default_export_format';
  static const _keyAutoIncludeDataDict = 'auto_include_data_dict';
  static const _keyFileNamingPattern = 'file_naming_pattern';
  static const _keyOutputDirectory = 'output_directory';
  static const _keyRecentProjects = 'recent_projects';
  static const _keyExportCount = 'export_count';
  static const _keyOnboardingComplete = 'onboarding_complete';

  static Future<AppConfig> load() async {
    final prefs = await SharedPreferences.getInstance();

    return AppConfig(
      enableModelParsing: prefs.getBool(_keyEnableModelParsing) ?? true,
      strictMode: prefs.getBool(_keyStrictMode) ?? false,
      includeSoftDeletes: prefs.getBool(_keyIncludeSoftDeletes) ?? true,
      ignoredTables: prefs.getStringList(_keyIgnoredTables) ?? [],
      defaultLayout: prefs.getString(_keyDefaultLayout) ?? 'grid',
      colorScheme: prefs.getString(_keyColorScheme) ?? 'light',
      lineStyle: prefs.getString(_keyLineStyle) ?? 'curved',
      notationStyle: prefs.getString(_keyNotationStyle) ?? 'crowsFoot',
      defaultExportFormat:
          prefs.getString(_keyDefaultExportFormat) ?? 'mermaid',
      autoIncludeDataDict: prefs.getBool(_keyAutoIncludeDataDict) ?? true,
      fileNamingPattern:
          prefs.getString(_keyFileNamingPattern) ?? '{project}_erd',
      outputDirectory: prefs.getString(_keyOutputDirectory) ?? '',
    );
  }

  static Future<void> save(AppConfig config) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyEnableModelParsing, config.enableModelParsing);
    await prefs.setBool(_keyStrictMode, config.strictMode);
    await prefs.setBool(_keyIncludeSoftDeletes, config.includeSoftDeletes);
    await prefs.setStringList(_keyIgnoredTables, config.ignoredTables);
    await prefs.setString(_keyDefaultLayout, config.defaultLayout);
    await prefs.setString(_keyColorScheme, config.colorScheme);
    await prefs.setString(_keyLineStyle, config.lineStyle);
    await prefs.setString(_keyNotationStyle, config.notationStyle);
    await prefs.setString(_keyDefaultExportFormat, config.defaultExportFormat);
    await prefs.setBool(_keyAutoIncludeDataDict, config.autoIncludeDataDict);
    await prefs.setString(_keyFileNamingPattern, config.fileNamingPattern);
    await prefs.setString(_keyOutputDirectory, config.outputDirectory);
  }

  static Future<List<String>> loadRecentProjects() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyRecentProjects) ?? [];
  }

  static Future<void> saveRecentProjects(List<String> projects) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyRecentProjects, projects);
  }

  static Future<void> addRecentProject(String path) async {
    final recent = await loadRecentProjects();
    recent.remove(path);
    recent.insert(0, path);
    if (recent.length > 5) recent.removeRange(5, recent.length);
    await saveRecentProjects(recent);
  }

  static Future<int> getExportCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyExportCount) ?? 0;
  }

  static Future<void> incrementExportCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_keyExportCount) ?? 0;
    await prefs.setInt(_keyExportCount, count + 1);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingComplete, true);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
