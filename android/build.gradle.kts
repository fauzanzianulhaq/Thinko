buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Pastikan versi ini sesuai
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// --- BAGIAN YANG DIPERBAIKI (Ganti nama variable) ---
// Kita ubah 'newBuildDir' menjadi 'globalBuildDir' supaya tidak error Ambiguity
val globalBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(globalBuildDir)

subprojects {
    // Gunakan variabel baru 'globalBuildDir' di sini
    val newSubprojectBuildDir = globalBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// ----------------------------------------------------

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}