import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:poepoe/main.dart';

void main() {
  testWidgets('App boots and shows chats screen', (tester) async {
    await tester.pumpWidget(const PoePoeApp());
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('PoePoe'), findsWidgets);
  });
}
