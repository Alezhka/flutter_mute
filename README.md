# flutter_mute

A Flutter plugin to check or toggle a device ringer mode.

## Features
1. Detect device current ringer mode;
2. Able to toggle between Normal, Silent & Vibrate mode (Only for Android);
3. Grant notification policy access for devices above platform version `Android 7.0 (API 24)`.

##### List of modes available
| Mode  | Description |
|---|---|
| RingerMode.Normal  | Device normal mode  |
| RingerMode.Silent  | Device silent mode  |
| RingerMode.Vibrate  | Device vibrate mode  |

## Example
To get the device's current sound mode:
 
```dart
import 'package:flutter_mute/flutter_mute.dart';

RingerMode ringerMode = await FlutterMute.getRingerMode;
```

To change the device ringer mode:

```dart
import 'package:flutter_mute/flutter_mute.dart';

await FlutterMute.setSoundMode(RingerMode.Silent); // Ignore for Android < 7.0
```

#### For Android 7.0 and above
For devices with Android 7.0 and above, it is required for the user to grant notification policy access to set their device's sound mode. 

To check if the user has granted the permissions and prompt for approval
```dart
import 'package:flutter_mute/flutter_mute.dart';

bool isAccessGranted = await FlutterMute.isNotificationPolicyAccessGranted;

if (!isAccessGranted) {
  // Opens the notification settings to grant the access.
  await FlutterMute.openNotificationPolicySettings();
}
```