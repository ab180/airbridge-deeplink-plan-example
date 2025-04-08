# Airbridge DeepLink Plan Guide - Android Example App

This repository provides an Android example app demonstrating how to implement and test deep linking using Airbridge.

## 🛠️ Environment Setup

To build and run this project locally, please make sure your development environment meets the following requirements:

### Prerequisites

- **JDK** 17
- **Gradle** version is handled via the Gradle Wrapper

## 🔧 Customizable Build Configuration

You can customize the build by passing Gradle properties via shell commands.

### ✅ Required Properties

| Property | Description |
| -- | -- |
| appName | The unique identifier used in the Airbridge SDK and tracking link URLs. |
| appToken | The unique identifier for integrating the Airbridge App SDK into your app. |

The `appName` and `appToken` can be found on the **[Settings]>[Tokens]** page in the Airbridge dashboard.

### ⚙️ Optional Properties

| Property | Description | Default Value | 
| -- | -- | -- |
| applicationId | The package name of the application. | co.ab180.airbridge.deeplinkplan.example |
| enableSignedApk | Enables signing via Gradle. | false |
| keystoreBase64 | Base64-encoded keystore file. |
| storePassword | A secure password for your keystore. |
| keyAlias | An identifying name for your key. |
| keyPassword | A secure password for your key. |

These properties can be passed using the `-P` flag when building the project.

### 🧪 Example Build Command

```shell
./gradlew clean :app:assembleDebug \
  -PapplicationId=com.example \
  -PappName=example \
  -PappToken=1234567890abcdef1234567890abcdef
```

## 🔐 Generating a Signed APK

There are two ways to generate a signed APK for this project.

### Sign APK via Gradle Properties

You can pass signing credentials directly as Gradle properties during the build.

1. Encode your keystore file to Base64
   
   ```shell
   base64 -i <keystore-file-path> | pbcopy
   ```

3. Run the build command with signing properties
   
   ```shell
   ./gradlew clean :app:assembleRelease \
     -PapplicationId=com.example \
     -PappName=example \
     -PappToken=1234567890abcdef1234567890abcdef
     -PenableSignedApk \
     -PkeystoreBase64=BASE64_ENCODED_KEYSTORE \
     -PstorePassword=XXXX \
     -PkeyAlias=XXXX \
     -PkeyPassword=XXXX
   ```
   
### Sign APK Manually Using apksigner

You can also generate an unsigned APK first, then manually sign it using the apksigner tool from the Android SDK.

1. Build unsigned APK

   ```shell
   ./gradlew clean :app:assembleRelease \
     -PapplicationId=com.example \
     -PappName=example \
     -PappToken=1234567890abcdef1234567890abcdef
   ```

2. Sign the APK

   ```shell
   apksigner sign --ks <keystore-file-path> \
     --ks-key-alias XXXX \
     --ks-pass pass:XXXX \
     --key-pass pass:XXXX \
     --out \
     ./app/build/outputs/apk/release/app-release.apk \
     ./app/build/outputs/apk/release/app-release-unsigned.apk
   ```