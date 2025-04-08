import org.gradle.api.Project

class ProjectConfig(project: Project) {

    private val propertyHandler = PropertyHandler(project)

    val applicationId: String
        get() = propertyHandler.getString(APPLICATION_ID, "co.ab180.airbridge.deeplinkplan.example")

    val airbridgeAppName: String
        get() = propertyHandler.getString(AIRBRIDGE_APP_NAME, "")

    val airbridgeAppToken: String
        get() = propertyHandler.getString(AIRBRIDGE_APP_TOKEN, "")

    val enableSignedApk: Boolean get() = propertyHandler.hasProperty(ENABLE_SIGNED_APK)

    // Signing Key
    val keystoreBase64: String? get() = propertyHandler.optString(KEYSTORE_BASE64)
    val storePassword: String? get() = propertyHandler.optString(STORE_PASSWORD)
    val keyAlias: String? get() = propertyHandler.optString(KEY_ALIAS)
    val keyPassword: String? get() = propertyHandler.optString(KEY_PASSWORD)

    companion object {
        const val APPLICATION_ID        = "applicationId"
        const val AIRBRIDGE_APP_NAME    = "appName"
        const val AIRBRIDGE_APP_TOKEN   = "appToken"
        const val ENABLE_SIGNED_APK     = "enableSignedApk"
        const val KEYSTORE_BASE64       = "keystoreBase64"
        const val STORE_PASSWORD        = "storePassword"
        const val KEY_ALIAS             = "keyAlias"
        const val KEY_PASSWORD          = "keyPassword"
    }
}