import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mute/flutter_mute.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  RingerMode _mode;
  String _permissionStatus;

  @override
  void initState() {
    super.initState();
    getRingerMode();
    getAccessStatus();
  }

  Future<void> getRingerMode() async {
    RingerMode mode;
    try {
      mode = await FlutterMute.getRingerMode();
    } catch (err) {
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _mode = mode;
    });
  }

  Future<void> getAccessStatus() async {
    bool isAccessGranted = false;
    try {
      isAccessGranted = await FlutterMute.isNotificationPolicyAccessGranted;
      print(isAccessGranted);
    } catch (err) {
      print(err);
    }

    setState(() {
      _permissionStatus = isAccessGranted ? "Access granted" : "Access not granted";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter mute'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Running on: $_mode\n $_permissionStatus'),
              RaisedButton(
                onPressed: getRingerMode,
                child: Text('Get ringer mode'),
              ),
              RaisedButton(
                onPressed: getAccessStatus,
                child: Text('Get access status'),
              ),
              RaisedButton(
                onPressed: setNormalMode,
                child: Text('Set Normal mode'),
              ),
              RaisedButton(
                onPressed: setSilentMode,
                child: Text('Set Silent mode'),
              ),
              RaisedButton(
                onPressed: setVibrateMode,
                child: Text('Set Vibrate mode'),
              ),
              RaisedButton(
                onPressed: openNotificationPolicySettings,
                child: Text('Open Policy Access Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setSilentMode() async {
    try {
      await FlutterMute.setRingerMode(RingerMode.Silent);
    } on PlatformException {
      print('Access is not granted!');
    }
  }

  Future<void> setNormalMode() async {
    try {
      await FlutterMute.setRingerMode(RingerMode.Normal);
    } on PlatformException {
      print('Access is not granted!');
    }
  }

  Future<void> setVibrateMode() async {
    try {
      await FlutterMute.setRingerMode(RingerMode.Vibrate);
    } on PlatformException {
      print('Access is not granted!');
    }
  }

  Future<void> openNotificationPolicySettings() async {
    await FlutterMute.openNotificationPolicySettings();
  }
}
