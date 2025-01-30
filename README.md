# POD-Capture
## Description
POD-Capture is a mobile application that focuses on streamlining manufacturing businesses supply chain by ommiting the need for paper copies of documents such as invoices, delivery notes etc. POD-Capture ensures paper documentation can be electronically scanned by delivery drivers, saved and uploaded directly to the business backend systems.

What is a POD (proof of delivery)?
A proof of delivery is simply a document or digital record that confirms a recipient has received the correct goods. It is a vital part of the sales process and supply chain helping to ensure that customers receive their orders accurately and in good condition. 

## Prerequisites  
### IDE
If you already have VSCode (version >=1.77) setup then skip this step.
To run this project, the preffered IDE would be VSCode on a Windows operating system as that is uniform to the development environment. You will also need to add the dart and flutter extensions to VSCode. 
If you do not already have VSCode installed for windows the follow the step by step guide here: [install vscode](https://docs.flutter.dev/get-started/editor?tab=vscode)

### Flutter SDK
Once you have setup your IDE you will need the Flutter SDK. You can follow the following steps to download the SDK within VScode [here](https://docs.flutter.dev/get-started/install/windows/desktop) 

### Packages 
All the necessary packages can be found in the pubspec.yaml file. After cloning the repository run the command "flutter pub get" to install the required packages. To upgrade the packages to the latest compatible versions run "flutter pub upgrade".

### Hardware
To be able to run this project you will also need to have an android (version >=6) or be running an android SDK (version >=23)
You will also need to have a wire that you can connect to your computer and to the android device to allow the app to compile. 
To do this your device will need to be in developer mode with USB debugging enabled. To read on how to do this see [here](https://developer.android.com/studio/debug/dev-options)

## Installation Guide & Running
### Step 1 Extract ZIP
Download the code as a zip file and it should appear in your downloads directory (e.g. C:\path\to\Downloads\pod_capture_app-master.zip)
Now you want to extract the contents of the zip to a new directory (e.g. C:\Users\yourUsername\testEnvironment)
### Step 2 Open Project
Open VSCode
Click file -> Open Folder
Select the extracted project folder and open it
### Step 3 Install Packages
Open the terminal within vscode
Run the following command "flutter pub get" to install all dependancies
### Step 4 Check For Erros
To ensure the installation of packages was successful 
Run "flutter doctor"
If the are any erros see troubleshooting section
### Step 5 Choose Device
Connect your android device via USB and enable USB debugging
Run "flutter devices"
### Step 6 Run Project
Lastly, run the app using: "flutter run"
This will begin the build process on the connected device!

## Contributing 
WIP. 

## License 
