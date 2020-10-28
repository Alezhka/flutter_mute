package com.github.alezhka.flutter_mute.data


import android.media.AudioManager
import com.github.alezhka.flutter_mute.domain.AudioManagerService
import com.github.alezhka.flutter_mute.entities.RingerMode

class AudioManagerServiceImpl(private val audioManager: AudioManager) : AudioManagerService {

    override fun getCurrentRingerMode(): RingerMode? {
        return when (audioManager.ringerMode) {
            AudioManager.RINGER_MODE_NORMAL -> RingerMode.NORMAL
            AudioManager.RINGER_MODE_SILENT -> RingerMode.SILENT
            AudioManager.RINGER_MODE_VIBRATE -> RingerMode.VIBRATE
            else -> null
        }
    }

    override fun setRingerMode(ringerMode: RingerMode) {
        audioManager.ringerMode = when (ringerMode) {
            RingerMode.NORMAL -> AudioManager.RINGER_MODE_NORMAL
            RingerMode.SILENT -> AudioManager.RINGER_MODE_SILENT
            RingerMode.VIBRATE -> AudioManager.RINGER_MODE_VIBRATE
        }
    }
}
