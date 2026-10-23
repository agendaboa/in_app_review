import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review_example/main.dart';

void main() {
  testWidgets('shows the in-app review example actions', (tester) async {
    await tester.pumpWidget(const InAppReviewExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('In App Review Example'), findsOneWidget);
    expect(find.text('Request Review'), findsOneWidget);
    expect(find.text('Open Store Listing'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
