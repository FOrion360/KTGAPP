plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // khuyến nghị dùng id chính thức
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.kenhtingame.ktg_news_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // Nếu dùng AGP 8.x, khuyến nghị Java 17:
        // sourceCompatibility = JavaVersion.VERSION_17
        // targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
        // Với Java 17:
        // jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.kenhtingame.ktg_news_app"
        minSdk = flutter.minSdkVersion
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

dependencies {
    // Bắt buộc để dùng Theme Material (fix lỗi Theme.MaterialComponents/Material3)
    implementation("com.google.android.material:material:1.12.0")

    // SplashScreen API cho Android 12+
    implementation("androidx.core:core-splashscreen:1.0.1")

    // (Tuỳ chọn) AppCompat nếu bạn cần các widget cũ:
    // implementation("androidx.appcompat:appcompat:1.7.0")

    // (Tuỳ chọn) Nếu vẫn giữ các <meta-data>/Activity của Facebook trong Manifest:
    // implementation("com.facebook.android:facebook-android-sdk:16.3.0")
}
