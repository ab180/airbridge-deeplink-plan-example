import org.gradle.api.Project

class PropertyHandler(private val project: Project) {

    fun hasProperty(name: String): Boolean = project.hasProperty(name)

    fun optString(name: String): String? =
        (project.findProperty(name) as? String)

    fun getString(name: String, fallback: String): String =
        optString(name) ?: fallback

    fun getBoolean(name: String, fallback: Boolean): Boolean =
        optString(name)?.toBooleanStrictOrNull() ?: fallback

    fun getDouble(name: String, fallback: Double): Double =
        optString(name)?.toDoubleOrNull() ?: fallback

    fun getInt(name: String, fallback: Int): Int =
        optString(name)?.toIntOrNull() ?: fallback

    fun getLong(name: String, fallback: Long): Long =
        optString(name)?.toLongOrNull() ?: fallback
}