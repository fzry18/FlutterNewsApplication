import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/app.dart';
import 'package:news_app/di/injection_container.dart' as di;

void main() {
  setUpAll(() async {
    await di.init();
  });

  testWidgets('NewsApp should build without errors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NewsApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
