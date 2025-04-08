import org.gradle.api.Project
import java.io.File
import java.util.Base64

internal const val KEYSTORE_FILE = "release.keystore"

internal fun saveKeystore(project: Project, encoded: String): Boolean {
    val keystoreFile = File(project.projectDir, KEYSTORE_FILE)
    base64Decode(encoded)?.let { decoded ->
        try {
            keystoreFile.outputStream().use { it.write(decoded) }
            return true
        } catch (e: Throwable) {
            println("Failed to write file: ${e.message}")
        }
    }
    return false
}

private fun base64Decode(encoded: String): ByteArray? = try {
    Base64.getDecoder().decode(encoded)
} catch (e: Throwable) {
    println("Failed to decode Base64 string: ${e.message}")
    null
}