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
                        "appName" to config.airbridgeAppName,
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
}