
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

/// Ringer Mode
enum RingerMode {

  Normal,

  Silent, // Only for android.

  Vibrate
}

class FlutterMute {

  static const MethodChannel _channel = const MethodChannel('flutter_mute');

  /// Gets the current device ringer mode.
  static Future<RingerMode> getRingerMode() async {
    final raw = await _channel.invokeMethod("getRingerMode");
    return RingerMode.values[raw];
  }

  /// Sets the device sound mode. (Only for android)
  ///
  /// Pass in either one of the following enum from [RingerMode] to set the
  /// device's sound mode.
  ///
  /// Throws [PlatformException] if the current device's API version is 24 and
  /// above. Require user's grant for Do Not Disturb Access, call the function
  /// [openNotificationPolicySettings] before calling this function.
  static Future<void> setRingerMode(RingerMode mode) async {
    if(!Platform.isAndroid) {
      return;
    }

    final raw = RingerMode.values.indexOf(mode);
    if(raw != -1) {
      await _channel.invokeMethod("setRingerMode", {
        'mode': raw,
      });
    }
  }

  /// Required to call this function for devices with API 24 and above.
  /// Gets notification policy access status.
  static Future<bool> get isNotificationPolicyAccessGranted async {
    if(!Platform.isAndroid) {
      return true;
    }

    final isGranted = await _channel.invokeMethod("isNotificationPolicyAccessGranted");
    return isGranted;
  }

  /// Open settings notification policy.
  static Future<void> openNotificationPolicySettings() async {
    if(!Platform.isAndroid) {
      return;
    }

    await _channel.invokeMethod("openNotificationPolicySettings");
  }
}
