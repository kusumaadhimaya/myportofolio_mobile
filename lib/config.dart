/// Base URL of the Django REST Framework API.
///
/// Defaults to `http://10.0.2.2:8000` for the Android emulator.
/// Override with `--dart-define=API_BASE_URL=http://localhost:8000` for Chrome.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
