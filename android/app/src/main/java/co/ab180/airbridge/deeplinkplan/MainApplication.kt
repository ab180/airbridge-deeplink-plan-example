package co.ab180.airbridge.deeplinkplan

import android.app.Application
import co.ab180.airbridge.Airbridge
import co.ab180.airbridge.AirbridgeLogLevel
import co.ab180.airbridge.AirbridgeOptionBuilder

class MainApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        val option =
            AirbridgeOptionBuilder(BuildConfig.AIRBRIDGE_APP_NAME, BuildConfig.AIRBRIDGE_APP_TOKEN)
                .setLogLevel(AirbridgeLogLevel.DEBUG)
                .build()
        Airbridge.initializeSDK(this, option)
    }
}