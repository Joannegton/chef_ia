plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.com.joannegton.chef_ia"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        // Debug config (for testing)
        getByName("debug") {
            val debugKeystorePath = System.getenv("DEBUG_KEYSTORE_PATH") 
                ?: "${System.getProperty("user.home")}/.android/debug.keystore"
            storeFile = file(debugKeystorePath)
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
        
        // Release config
        create("release") {
            val keyAlias = System.getenv("KEY_ALIAS")
            val keyPassword = System.getenv("KEY_PASSWORD")
            val keystorePath = System.getenv("KEYSTORE_PATH") ?: "../chef_ia_key.jks"
            val storePassword = System.getenv("KEYSTORE_PASSWORD")
            
            // Only set signing config if all credentials are provided
            if (!keyAlias.isNullOrEmpty() && !keyPassword.isNullOrEmpty() && !storePassword.isNullOrEmpty()) {
                this.keyAlias = keyAlias
                this.keyPassword = keyPassword
                this.storeFile = file(keystorePath)
                this.storePassword = storePassword
            } else {
                // Fallback to debug signing if credentials not provided
                val debugKeystorePath = System.getenv("DEBUG_KEYSTORE_PATH") 
                    ?: "${System.getProperty("user.home")}/.android/debug.keystore"
                storeFile = file(debugKeystorePath)
                this.keyAlias = "androiddebugkey"
                this.keyPassword = "android"
                this.storePassword = "android"
            }
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "br.com.joannegton.chef_ia"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
            
            // Desabilitar minify e shrink para evitar problemas com dependências
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
