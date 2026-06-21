allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    // Corrected afterEvaluate block for Kotlin DSL
    afterEvaluate {
        val subProject = this
        if (subProject.hasProperty("android")) {
            val androidExtension = subProject.extensions.findByName("android")

            // Use reflection to set namespace if the plugin hasn't defined it
            try {
                val getNamespace = androidExtension?.javaClass?.getMethod("getNamespace")
                val setNamespace = androidExtension?.javaClass?.getMethod("setNamespace", String::class.java)

                val currentNamespace = getNamespace?.invoke(androidExtension)
                if (currentNamespace == null) {
                    // Falls back to the project group name (e.g., io.github.boskokg...)
                    setNamespace?.invoke(androidExtension, subProject.group.toString())
                }
            } catch (e: Exception) {
                // Silently skip if the android extension doesn't support namespace yet
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}