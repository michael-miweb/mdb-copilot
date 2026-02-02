import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/app/app.dart';

void main() {
  group('App', () {
    testWidgets('renders', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const App(apiBaseUrl: 'http://localhost:4080/api'),
        );
        await tester.pump();
      });
      expect(find.byType(App), findsOneWidget);
    });
  });
}
