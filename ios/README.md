# Airbridge DeepLink Plan Guide - iOS Example App

This repository provides an iOS example app demonstrating how to implement and test deep linking using Airbridge.

## 🛠️ Environment Setup

To build and run this project locally, please make sure your development environment meets the following requirements:

### Prerequisites

- **XCode**

## 🔧 Customizable Build Configuration

You can customize the build by passing properties to the **configure_app.sh** shell command.

### ✅ Required Properties

| Property | Description |
| -- | -- |
| -n | The unique identifier used in the Airbridge SDK and tracking link URLs. |
| -t | The unique identifier for integrating the Airbridge App SDK into your app. |
| -s | URL scheme configuration (multiple allowed) |
| -d | Universal link domain configuration (multiple allowed) |

The `appName` and `appToken` can be found on the **[Settings]>[Tokens]** page in the Airbridge dashboard.

### 🧪 Example Build Command

```shell
./script/configure_app.sh -n MyApp -t my_token -s myapp myapp2 -d example.com test.com
```