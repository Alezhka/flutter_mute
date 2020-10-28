package com.github.alezhka.flutter_mute.domain

import android.content.Context

interface IntentManagerService {

    fun isAccessGranted(): Boolean

    fun launchSettings(context: Context)

}