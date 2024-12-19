# StreamKeys

**StreamKeys** is a cross-platform application that allows you to configure and control actions on a Windows computer using a keyboard or an Android mobile device over a local Wi-Fi network.

## Description

The application consists of two parts:
1. **StreamKeys for Windows** — you can configure buttons to control various actions on your computer, such as opening programs, websites, or running macros. The server runs over your local network, allowing a mobile application to connect to your computer via its IP address. This allows you to remotely control your computer using your mobile device or keyboard. The application runs over the local network, allowing the mobile app to connect to it via the computer's IP address.
2. **StreamKeys for Android** — When a button is pressed on the mobile device, a request is sent to the server, and if the Windows app is running, the corresponding executable file for that button is triggered.

## Features

- **Touch Deck for Android** — Allows to configure a grid of buttons on their mobile device to control actions on their computer.
- **Keyboard Deck for Windows** — Enables configuring key assignments and macros for keyboard devices.
- **Customizable Buttons** — Add actions such as launching apps, opening websites, and more to the buttons.
- **HID Macros Support** — Integrate HID Macros for additional functionality with your keyboard setup.

## Usage Guide

### Installing StreamKeys for Windows

**Download and Install:**
- Download the StreamKeys-Windows.zip file.
- Extract the files and install StreamKeys for Windows.

**Launch the App:**
- Open StreamKeys for Windows.

**Configure Buttons for Touch Deck:**
1. **Adding a New Page:**
   - In the left panel, click the "Add page" button.
   - A new page will appear in the list on the left. Click on it to edit.
2. **Choosing a Button Grid:**
   - In the central part of the screen, find the dropdown menu with the grid size (e.g., "Grid [7x4]").
   - Select your preferred grid size. The number of buttons on the page will adjust automatically.
3. **Customizing Buttons:**
   - Click on any button in the grid to open the settings panel at the bottom of the screen.
   - In the "Setting Button" section:
     - Click the folder icon to upload an image for the button.
     - Choose a button color using the palette.
     - Enter a name for the button in the "Name" text field.
     - Click "Update" to save the changes.
4. **Adding Actions to Buttons:**
   - Navigate to the right panel and expand either Toolbox or OBS Studio.
   - Choose an action, such as:
     - Open app/file — to launch programs or files.
     - Website — to open a website.
   - Drag and drop the chosen action onto the desired button in the grid.
   - You can add multiple actions to a single button. The button will execute all assigned actions in the order they were added.
5. **Removing Buttons or Actions:**
   - To remove an action: Click the button, open settings, and select the option to clear the action.
   - To delete an entire page: Click the trash icon next to the page name in the left panel.

**Server Status:**
- The app will automatically start the server and be ready to accept requests from the mobile app.
- In the top section of the app, you can see:
  - Device name — the name of your PC.
  - Device IPv4 — the local IP address to identify which device to connect to in the Android app (StreamKeys-Android).

### Installing StreamKeys for Android (if you want to use Touch Deck)

**Install the App:**
- Download and install StreamKeys-Android on your Android mobile device.

**Connect to Wi-Fi:**
- Ensure your mobile device is connected to the same local Wi-Fi network as your computer.

**Select Your Computer:**
- Open the app and choose your computer from the list to connect to the server application (StreamKeys-Windows).

**Use Touch Deck:**
- After connecting, you will see all the buttons configured on the server.
- Tap any button to perform the corresponding actions (all actions assigned to the button will be executed in sequence).

### Configure Buttons for Keyboard Deck:

**Select HID Macros Configuration File:**
- When setting up for the first time, you will be prompted to select the HID Macros configuration XML file.
- To do this:
  - Download and install HID Macros.
  - Launch it at least once so that the macros.xml file is created in the program folder.

**Choose Keyboard and Layout:**
- After selecting the XML file, you will be able to configure the keyboard above the keyboard map:
  - Choose the keyboard from the list of connected devices to reassign keys.
  - Select the keyboard type:
    - full — full-size keyboard.
    - compact — compact keyboard.
    - numpad — numeric keypad only.

**Generate Scripts and Update XML:**
- After selecting the keyboard and form factor, you need to:
  - Generate VBS scripts and update the XML file for HID Macros.
- Close HID Macros before doing this, as it does not update the configuration while running.
- After updating the files, you can launch HID Macros again.

**Customize Keyboard Buttons:**
- Customizing buttons is similar to Touch Deck, but now you are working with keyboard buttons:
  - The button grid will display the appearance of the keyboard based on the selected form factor.
  - Add multiple actions to a single key (all actions will be executed sequentially).
- After updating the button settings, there is no need to regenerate VBS scripts or update the XML file.

**Note:**
- In future updates, the functionality with HID Macros will be simplified to minimize actions.
- If macros in HID Macros are not working:
  - Select any macro in HID Macros and reselect the same XML file. This will resolve the issue.

## Technologies

- **Flutter** — for developing both parts of the application (Windows and Android).
- **Wi-Fi network** — for communication between the computer and the mobile device.
- **HID macros** — for keyboard functionality.

## License

This project is licensed under the MIT License.  

[MIT LICENSE](https://github.com/yevheniy-hliebov/StreamKeys/blob/main/LICENSE.txt)
