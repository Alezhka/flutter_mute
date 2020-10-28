package com.github.alezhka.flutter_mute

import android.app.NotificationManager
import android.content.Context
import android.content.Context.NOTIFICATION_SERVICE
import android.media.AudioManager
import androidx.annotation.NonNull
import com.github.alezhka.flutter_mute.data.AudioManagerServiceImpl
import com.github.alezhka.flutter_mute.data.IntentManagerServiceImpl
import com.github.alezhka.flutter_mute.domain.AudioManagerService
import com.github.alezhka.flutter_mute.domain.IntentManagerService
import com.github.alezhka.flutter_mute.entities.RingerMode
import com.github.alezhka.flutter_mute.utils.ErrorUtil
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterMutePlugin */
class FlutterMutePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var context: Context? = null
  private var audioManagerService: AudioManagerService? = null
  private var intentManagerService: IntentManagerService? = null

  private val isAccessGranted
    get() = intentManagerService?.isAccessGranted() ?: false

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val context = flutterPluginBinding.applicationContext
    val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    audioManagerService = AudioManagerServiceImpl(audioManager)

    val notificationManager = context.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
    intentManagerService = IntentManagerServiceImpl(notificationManager)

    this.context = context

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_mute")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getRingerMode" -> {
        getCurrentRingerMode(result)
      }
      "setRingerMode" -> {
        val raw = call.argument<Int>("mode") ?: RingerMode.NORMAL.index
        val mode = RingerMode.values()[raw]
        setCurrentRingerMode(result, mode)
      }
      "openNotificationPolicySettings" -> {
        intentManagerService?.launchSettings(context!!)
      }
      "isNotificationPolicyAccessGranted" -> {
        getPermissionStatus(result)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    audioManagerService = null
    intentManagerService = null
    context = null
  }

  private fun setCurrentRingerMode(result: Result, ringerMode: RingerMode) {
    if (!isAccessGranted) {
      result.error(
              ErrorUtil.InvalidPermission.errorCode,
              ErrorUtil.InvalidPermission.errorMessage,
              ErrorUtil.InvalidPermission.errorDetails
      )
      return
    }
    audioManagerService?.setRingerMode(ringerMode)
    result.success(true)
  }

  private fun getCurrentRingerMode(result: Result) {
    val ringerMode = audioManagerService?.getCurrentRingerMode()
    if (ringerMode == null) {
      result.error(
              ErrorUtil.ServiceUnavailable.errorCode,
              ErrorUtil.ServiceUnavailable.errorMessage,
              ErrorUtil.ServiceUnavailable.errorDetails
      )
      return
    }
    result.success(ringerMode.index)
  }

  private fun getPermissionStatus(result: Result) {
    result.success(isAccessGranted)
  }
}
