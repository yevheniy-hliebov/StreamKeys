# StreamKeys

**StreamKeys** is a cross-platform application that allows you to configure and control actions on a Windows computer using an Android mobile device over a local Wi-Fi network.

## Description

The application consists of two parts:
1. **StreamKeys for Windows** — the server component that operates as a local server. You can configure 28 buttons with specific parameters:
   - **Button name**
   - **Button image**
   - **Path to the executable file** (.exe, .bat, .vbs, etc.)
   
   The server runs over the local network, allowing the mobile app to connect to it via the computer's IP address.

2. **StreamKeys for Android** — the client component that connects to the server via the computer's IP address. After successfully connecting, the app retrieves a list of all 28 buttons.
   
   When a button is pressed on the mobile device, a request is sent to the server, and if the Windows app is running, the corresponding executable file for that button is triggered.

## Features

- Сonfigure 28 buttons for quick execution of various files on the computer (e.g., launching programs, scripts, etc.).
- Connect the Android mobile app to the Windows server via a local Wi-Fi network.
- Display configured buttons in the mobile app.
- Pressing a button on the mobile device triggers the corresponding action on the computer.

## Usage Guide

### Installing StreamKeys for Windows
1. Download zip [StreamKeys-Windows](https://github.com/yevheniy-hliebov/StreamKeys/releases/download/v1.0.0/StreamKeys-Windows.zip) and install StreamKeys for Windows.
2. Launch the app and configure buttons:
   - Specify the button name, choose an image (if needed), and set the path to the file to be executed.
   - Save the configuration.
3. The app will automatically start the server and will be ready to accept requests from the mobile app.

### Installing StreamKeys for Android
1. Install [StreamKeys-Android](https://github.com/yevheniy-hliebov/StreamKeys/releases/download/v1.0.0/StreamKeys-Android.apk) on your Android mobile device.
2. Connect to the same local Wi-Fi network as your computer.
3. Enter the IP address of your computer to connect to the server.
4. After connecting, you will see all configured buttons. Tap any button to perform the corresponding action on the computer.

## Technologies

- **Flutter** — for developing both parts of the application (Windows and Android).
- **Wi-Fi network** — for communication between the computer and the mobile device.

## Future Plans
- Add the ability to configure macros for buttons.
- Improve the UI and add the ability to upload custom button images via the mobile app.
- Add the ability to create profiles for different use cases (e.g., programming, streaming).
- Add the ability to change the number of buttons.
- Implement drag-and-drop functionality to reorder buttons.

## License
This project is licensed under the MIT License.  

[MIT LICENSE](https://github.com/yevheniy-hliebov/StreamKeys/blob/main/LICENSE.txt)
