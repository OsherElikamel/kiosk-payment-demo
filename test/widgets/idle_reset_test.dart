import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiosk_payment_demo/widgets/idle_reset.dart';

void main() {
  Widget buildSubject(void Function() onIdle) {
    return IdleReset(
      timeout: const Duration(seconds: 5),
      onIdle: onIdle,
      child: const ColoredBox(color: Colors.white),
    );
  }

  testWidgets('fires onIdle once the timeout elapses', (tester) async {
    var fired = 0;
    await tester.pumpWidget(buildSubject(() => fired++));

    await tester.pump(const Duration(seconds: 4));
    expect(fired, 0);

    await tester.pump(const Duration(seconds: 2));
    expect(fired, 1);
  });

  testWidgets('pointer activity restarts the countdown', (tester) async {
    var fired = 0;
    await tester.pumpWidget(buildSubject(() => fired++));

    await tester.pump(const Duration(seconds: 4));
    await tester.tapAt(const Offset(10, 10));
    await tester.pump(const Duration(seconds: 4));
    expect(fired, 0, reason: 'the tap should have reset the timer');

    await tester.pump(const Duration(seconds: 2));
    expect(fired, 1);
  });
}
