import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.chenille.comptabilite"
    compileSdk = 36  // Android 15+
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
    
    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        applicationId = "com.chenille.comptabilite"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 签名配置
    signingConfigs {
        create("release") {
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (keystorePropertiesFile.exists()) {
                val keystoreProperties = Properties()
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
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

// 构建前自动清理build文件夹
tasks.register("cleanBeforeBuild") {
    doLast {
        val rootBuildDir = project.rootProject.file("../build")
        val appBuildDir = layout.buildDirectory.get().asFile
        
        if (rootBuildDir.exists()) {
            rootBuildDir.deleteRecursively()
            println("🧹 已清理根目录 build 文件夹")
        }
        
        if (appBuildDir.exists()) {
            appBuildDir.deleteRecursively()
            println("🧹 已清理 android/app/build 文件夹")
        }
    }
}

// 自动复制APK到Flutter期望的目录
afterEvaluate {
    tasks.register("copyApkToFlutterDir") {
        doLast {
            val buildDir = layout.buildDirectory.get().asFile
            val flutterBuildDir = project.rootProject.file("../build/app/outputs/flutter-apk")
            
            // 确保目标目录存在
            flutterBuildDir.mkdirs()
            
            // 复制debug APK
            val debugApk = file("$buildDir/outputs/apk/debug/app-debug.apk")
            if (debugApk.exists()) {
                debugApk.copyTo(file("${flutterBuildDir}/app-debug.apk"), overwrite = true)
                println("✅ 已复制 debug APK 到: ${flutterBuildDir}/app-debug.apk")
            }
            
            // 复制release APK
            val releaseApk = file("$buildDir/outputs/apk/release/app-release.apk")
            if (releaseApk.exists()) {
                releaseApk.copyTo(file("${flutterBuildDir}/app-release.apk"), overwrite = true)
                println("✅ 已复制 release APK 到: ${flutterBuildDir}/app-release.apk")
            }
        }
    }
    
    // 在preBuild前执行清理
    tasks.findByName("preBuild")?.dependsOn("cleanBeforeBuild")
    
    // 在assembleDebug和assembleRelease后自动执行复制
    tasks.findByName("assembleDebug")?.finalizedBy("copyApkToFlutterDir")
    tasks.findByName("assembleRelease")?.finalizedBy("copyApkToFlutterDir")
}
