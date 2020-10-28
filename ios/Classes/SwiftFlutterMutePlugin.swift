import Flutter
import UIKit

public class SwiftFlutterMutePlugin: NSObject, FlutterPlugin {
    
    enum RingerMode: Int {
        case Normal = 0
        case Silent = 1
        case Vibrate = 2
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_mute", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterMutePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getRingerMode":
        if TARGET_OS_SIMULATOR != 0 {
            result(RingerMode.Normal)
            return
        }
        MuteDetect.shared.detectSound { (isMute) in
            let mode = isMute ? RingerMode.Vibrate : RingerMode.Normal
            result(mode.rawValue)
        }
        break
    default:
        result(FlutterMethodNotImplemented)
        break
    }
  }
}
