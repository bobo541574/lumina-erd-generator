import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../schema_parser/domain/models/project_schema.dart';
import '../../domain/services/project_parser.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/services/parse_cache.dart';

enum ProjectLoadState {
  idle,
  selected,
  validating,
  parsed,
  error,
}

class ProjectState {
  final String? directoryPath;
  final ProjectLoadState loadState;
  final ProjectParserResult? parserResult;
  final List<String> validationWarnings;
  final String? errorMessage;

  const ProjectState({
    this.directoryPath,
    this.loadState = ProjectLoadState.idle,
    this.parserResult,
    this.validationWarnings = const [],
    this.errorMessage,
  });

  ProjectState copyWith({
    String? directoryPath,
    ProjectLoadState? loadState,
    ProjectParserResult? parserResult,
    List<String>? validationWarnings,
    String? errorMessage,
  }) {
    return ProjectState(
      directoryPath: directoryPath ?? this.directoryPath,
      loadState: loadState ?? this.loadState,
      parserResult: parserResult ?? this.parserResult,
      validationWarnings: validationWarnings ?? this.validationWarnings,
      errorMessage: errorMessage,
    );
  }

  bool get hasProject => directoryPath != null;
  bool get isParsed => loadState == ProjectLoadState.parsed;
  bool get hasError => loadState == ProjectLoadState.error;
  bool get isParsing => loadState == ProjectLoadState.validating;

  ProjectSchema? get schema => parserResult?.schema;
}

class ProjectNotifier extends StateNotifier<ProjectState> {
  ProjectNotifier() : super(const ProjectState());

  final _cache = ParseCache();
  static const _enableModelParsing = true;

  Future<void> pickDirectory() async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Laravel Project Directory',
    );

    if (result == null) return;

    state = state.copyWith(
      directoryPath: result,
      loadState: ProjectLoadState.selected,
      errorMessage: null,
    );

    await _validateAndParse(result);
  }

  Future<void> loadFromPath(String path) async {
    state = state.copyWith(
      directoryPath: path,
      loadState: ProjectLoadState.selected,
      errorMessage: null,
    );

    await _validateAndParse(path);
  }

  Future<void> _validateAndParse(String path) async {
    state = state.copyWith(loadState: ProjectLoadState.validating);

    try {
      if (!ProjectParser.isLaravelProject(path)) {
        throw const InvalidLaravelProjectException();
      }

      final warnings = ProjectParser.validateLaravelProject(path);
      state = state.copyWith(validationWarnings: warnings);

      final cached = _cache.get(path);
      if (cached != null) {
        state = state.copyWith(
          loadState: ProjectLoadState.parsed,
          parserResult: cached,
        );
        return;
      }

      final result = await _runParsing(path);
      _cache.put(path, result);

      state = state.copyWith(
        loadState: ProjectLoadState.parsed,
        parserResult: result,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        loadState: ProjectLoadState.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        loadState: ProjectLoadState.error,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ProjectParserResult> _runParsing(String path) async {
    return ProjectParser.parse(path, enableModelParsing: _enableModelParsing);
  }

  void clearProject() {
    state = const ProjectState();
  }
}

final projectProvider = StateNotifierProvider<ProjectNotifier, ProjectState>(
  (ref) => ProjectNotifier(),
);

final projectSchemaProvider = Provider<ProjectSchema?>((ref) {
  return ref.watch(projectProvider).schema;
});

final recentProjectsProvider = StateProvider<List<String>>((ref) => []);

final enableModelParsingProvider = StateProvider<bool>((ref) => true);
