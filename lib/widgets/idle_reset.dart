import 'dart:async';

import 'package:flutter/material.dart';

/// Kiosk idle guard: fires [onIdle] after [timeout] with no pointer
/// activity, so an abandoned session returns to the welcome screen
/// instead of exposing the previous shopper's cart.
class IdleReset extends StatefulWidget {
  final Duration timeout;
  final VoidCallback onIdle;
  final Widget child;

  const IdleReset({
    super.key,
    this.timeout = const Duration(seconds: 90),
    required this.onIdle,
    required this.child,
  });

  @override
  State<IdleReset> createState() => _IdleResetState();
}

class _IdleResetState extends State<IdleReset> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _restart() {
    _timer?.cancel();
    _timer = Timer(widget.timeout, widget.onIdle);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _restart(),
      onPointerMove: (_) => _restart(),
      onPointerSignal: (_) => _restart(),
      child: widget.child,
    );
  }
}
