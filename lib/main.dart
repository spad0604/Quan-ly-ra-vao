import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Suppress noisy RawKeyboard assertion produced when an attached HID
  // device sends malformed modifier/key events. This avoids spamming the
  // debug console while developing. In release builds these asserts are
  // not present, so prefer testing in release for final verification.
  PlatformDispatcher.instance.onError = (error, stack) {
    final msg = error?.toString() ?? '';
    if (msg.contains('Attempted to send a key down event when no keys are in keysPressed') ||
        msg.contains('Unable to parse JSON message')) {
      return true; // handled - suppress HID-related errors
    }
    return false; // not handled
  };
  FlutterError.onError = (details) {
    final msg = details.exceptionAsString();
    if (msg.contains('Attempted to send a key down event when no keys are in keysPressed') ||
        msg.contains('Unable to parse JSON message')) {
      return; // swallow HID-related errors
    }
    FlutterError.presentError(details);
  };
  await dotenv.load(fileName: 'assets/env');
  runApp(const App());
}
