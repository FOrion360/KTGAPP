plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // khuyến nghị dùng id chính thức
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties

val keystorePropsFile = rootProject.file("/Users/user/Documents/GitHub/KTGAPP/android/key.properties")
val keystoreProperties = Properties().apply {
    if (!keystorePropsFile.exists()) {
        throw GradleException("Missing android/key.properties. Tạo file và điền storeFile/keyAlias/password.")
    }
    load(keystorePropsFile.inputStream())
}

fun req(name: String): String =
    keystoreProperties.getProperty(name)
        ?: throw GradleException("Missing '$name' in android/key.properties")

val storePath = req("storeFile")
val storeFileResolved = file(storePath)
if (!storeFileResolved.exists()) {
    throw GradleException("Keystore not found at: ${storeFileResolved.absolutePath}.\n" +
            "HINT: Nếu keystore ở ROOT, dùng 'storeFile=../../upload-keystore.jks'.")
}

android {
    namespace = "com.kenhtingame.ktg_news_app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        //sourceCompatibility = JavaVersion.VERSION_11
        //targetCompatibility = JavaVersion.VERSION_11
        // Nếu dùng AGP 8.x, khuyến nghị Java 17:
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        //jvmTarget = JavaVersion.VERSION_11.toString()
        // Với Java 17:
         jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.kenhtingame.ktg_news_app"
        minSdk = flutter.minSdkVersion // hoặc giá trị bạn đang dùng
        targetSdk = 36
        manifestPlaceholders["facebookAppId"] = "318591425269859"
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = storeFileResolved
            storePassword = req("storePassword")
            keyAlias = req("keyAlias")
            keyPassword = req("keyPassword")
        }
    }

    buildTypes {
        getByName("release") {
            // ⚠️ Đảm bảo KHÔNG dùng debug ở đây
            signingConfig = signingConfigs.getByName("release")
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
