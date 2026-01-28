import 'package:mdb_copilot/app/app.dart';
import 'package:mdb_copilot/bootstrap.dart';

Future<void> main() async {
  await bootstrap(
    () => const App(apiBaseUrl: 'https://staging-api.mdb-copilot.com/api'),
  );
}
