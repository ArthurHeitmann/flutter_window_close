import 'dart:async';
import 'dart:js_interop';

// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the FlutterHi plugin.
class FlutterWindowClosePluginWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'flutter_window_close',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = FlutterWindowClosePluginWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  FlutterWindowClosePluginWeb() {
    EventStreamProvider("beforeunload").forTarget(window).listen((event) {
      if (event.instanceOfString("BeforeUnloadEvent")) {
        if (_returnValue != null) {
          var beforeUnloadEvent = event as BeforeUnloadEvent;
          beforeUnloadEvent.preventDefault();
          beforeUnloadEvent.returnValue = _returnValue!;
        }
      }
    });
  }

  String? _returnValue;

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'setWebReturnValue':
        _returnValue = call.arguments;
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'flutter_hi for web doesn\'t implement \'${call.method}\'',
        );
    }
  }
}
