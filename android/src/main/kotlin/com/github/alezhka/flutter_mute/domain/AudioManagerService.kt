package com.github.alezhka.flutter_mute.domain

import com.github.alezhka.flutter_mute.entities.RingerMode

interface AudioManagerService {

    fun getCurrentRingerMode(): RingerMode?
    fun setRingerMode(ringerMode: RingerMode)

}