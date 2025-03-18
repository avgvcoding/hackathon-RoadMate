# Flutter Setup and Installation Guide

This guide explains how to install Flutter (and Dart) on your system, set up an Android device for development, and run your Flutter app on the device via USB.

---

## Prerequisites

- A computer running **Windows, macOS, or Linux**.
- Administrator privileges for installing software.
- A **USB cable** to connect your Android device.
- An **Android device** with Developer Options and USB Debugging enabled.

---

## 1. Installing Flutter

### a. Download the Flutter SDK

1. Visit the [Flutter installation page](https://flutter.dev/docs/get-started/install) and download the latest stable release for your operating system.
2. Extract the downloaded archive to a location of your choice:
   - **Windows:** `C:\src\flutter`
   - **macOS/Linux:** `~/development/flutter`

### b. Add Flutter to Your PATH

#### *Windows:*

1. Open **System Properties** > **Environment Variables**.
2. Under "User variables" (or "System variables"), add the full path to the `flutter\bin` directory.

#### *macOS/Linux:*

1. Open your terminal.
2. Edit your shell configuration file (`~/.bashrc`, `~/.zshrc`, or `~/.bash_profile`) and add:
   
   ```bash
   export PATH="$PATH:[PATH_TO_FLUTTER_DIRECTORY]/flutter/bin"
   ```
   
3. Save the file and run the following command to update your PATH:
   
   ```bash
   source ~/.bashrc   # or source ~/.zshrc
   ```

### c. Verify the Installation

1. Open a new terminal or command prompt.
2. Run the following command:
   
   ```bash
   flutter doctor
   ```

3. Review the output and complete any missing steps (e.g., installing missing dependencies or Android SDK components).

---

## 2. Setting Up Your Android Device

### a. Enable Developer Options

1. On your Android device, navigate to **Settings** > **About Phone**.
2. Tap **Build Number** seven times until you see a message indicating that Developer Options are enabled.
3. Go back to **Settings** and select **Developer Options**.

### b. Enable USB Debugging

1. In **Developer Options**, find and enable **USB Debugging**.
2. Confirm any prompts that appear on your device.

### c. Connect Your Device via USB

1. Use a **USB cable** to connect your Android device to your computer.
2. Ensure the device is recognized by running:
   
   ```bash
   flutter devices
   ```
   
3. If your device isn’t listed, you may need to install the appropriate **USB drivers** (especially on Windows).

---

## 3. Running Your Flutter App on an Android Device

1. Navigate to your Flutter project directory in your terminal.
2. Run the following command to build and deploy your app on the connected device:
   
   ```bash
   flutter run
   ```
   
3. The app should launch on your Android device.

---

## 4. Additional Configuration

### Android Studio Integration

- Install the **Flutter plugin** and the **Dart plugin** in **Android Studio** for enhanced development features.

### Troubleshooting

- If you encounter issues, refer to the [official Flutter documentation](https://flutter.dev/docs) or consult community forums for support.

---

Your environment is now ready for Flutter development! 🚀 Enjoy building your app and testing it on your Android device.

