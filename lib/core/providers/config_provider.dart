import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/config_service.dart';

final configProvider = StateNotifierProvider<ConfigNotifier, AppConfig>(
  (ref) => ConfigNotifier(),
);

class ConfigNotifier extends StateNotifier<AppConfig> {
  ConfigNotifier() : super(AppConfig.defaults()) {
    _load();
  }

  Future<void> _load() async {
    state = await ConfigService.load();
  }

  Future<void> update(AppConfig config) async {
    state = config;
    await ConfigService.save(config);
  }
}
