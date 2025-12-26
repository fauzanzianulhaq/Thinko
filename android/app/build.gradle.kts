plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.thinko"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.thinko" // Pastikan ini sesuai
        
        // --- UBAH BAGIAN INI (Wajib buat Firebase) ---
        minSdk = flutter.minSdkVersion   // Ganti flutter.minSdkVersion jadi 21
        multiDexEnabled = true 
        // --------------------------------------------

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// --- TAMBAHKAN BLOK INI DI PALING BAWAH (PENTING!) ---
dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
}
