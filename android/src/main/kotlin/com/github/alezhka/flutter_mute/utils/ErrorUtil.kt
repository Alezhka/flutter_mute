package com.github.alezhka.flutter_mute.utils

sealed class ErrorUtil {
    object InvalidPermission {
        const val errorCode = "NOT ALLOWED"
        const val errorMessage = "Do not disturb permissions not enabled for current device!"
        val errorDetails: String? = null
    }

    object ServiceUnavailable {
        const val errorCode = "UNAVAILABLE"
        const val errorMessage = "Unable to get ringer mode for the current device"
        val errorDetails: String? = null
    }
}