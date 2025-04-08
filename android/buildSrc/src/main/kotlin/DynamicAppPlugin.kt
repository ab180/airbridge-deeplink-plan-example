import com.android.build.api.dsl.ApplicationExtension
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.getByType

class DynamicAppPlugin : Plugin<Project> {

    override fun apply(project: Project) {
        configureDeeplinkExampleApp(project)
    }

    private fun configureDeeplinkExampleApp(project: Project) {
        val config = ProjectConfig(project)
        project.extensions.getByType<ApplicationExtension>().apply {
            defaultConfig {
                applicationId = config.applicationId

                buildConfigField("String", "AIRBRIDGE_APP_NAME", "\"${config.airbridgeAppName}\"")
                buildConfigField("String", "AIRBRIDGE_APP_TOKEN", "\"${config.airbridgeAppToken}\"")

                manifestPlaceholders.putAll(
                    mapOf(
                        AIRBRIDGE_SCHEME to config.airbridgeAppName,
                        AIRBRIDGE_APP_LINKS_1 to "${config.airbridgeAppName}.abr.ge",
                        AIRBRIDGE_APP_LINKS_2 to "${config.airbridgeAppName}.airbridge.io",
                    )
                )
            }

            if (config.enableSignedApk) {
                signingConfigs {
                    create("release") {
                        config.keystoreBase64?.let {
                            if (saveKeystore(project = project, encoded = it)) {
                                storeFile = project.file(KEYSTORE_FILE)
                            }
                        }
                        config.storePassword?.let { storePassword = it }
                        config.keyAlias?.let { keyAlias = it }
                        config.keyPassword?.let { keyPassword = it }
                    }
                }

                buildTypes {
                    release {
                        signingConfig = signingConfigs.getByName("release")
                    }
                }
            }
        }
    }

    companion object {
        const val AIRBRIDGE_SCHEME          = "airbridgeScheme"
        const val AIRBRIDGE_APP_LINKS_1     = "airbridgeAppLinks1"  // abr.ge
        const val AIRBRIDGE_APP_LINKS_2     = "airbridgeAppLinks2"  // airbridge.io
    }
}