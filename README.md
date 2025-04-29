![Build Status](https://github.com/cs481-ekh/s25-syncineers/actions/workflows/flutter-build.yaml/badge.svg)


# Easy Sync
![](easy_sync/assets/logo_smaller.png)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![](easy_sync/assets/sdp-logo-smaller.png)

BSU CS481 Capstone project

The easy Google Calendar integration tool

## Downloading the Latest Release
The latest release can be downloaded [here](https://drive.google.com/file/d/1xp9CS9LQLkNKdh8HJu6fRZwWEaRjbJvU/view?usp=sharing) (ZIP, 164.3 MB)

Simply download the zip file, extract it to a file location of you choice, then click on the executable named easy-sync.exe to run the program

If desired, a desktop shortcut can be created for the executable file by right clicking on it and selecting the 'Create Shortcut' option

## Installing and Running

To run the project in electron you first must install NodeJS and NPM which both can be installed through the link [here](https://nodejs.org/en/)

Flutter will also be needed to run the project, which can be downloaded from the link [here](https://docs.flutter.dev/get-started/install)

To verify if npm is installed use the following command: `npm -v`

To verify if flutter is installed use the following command: `flutter doctor` This will also output any changes that need to be made to run flutter

### Running in Electron for Deployment
To package a new executable with electron first make sure that both NodeJS and NPM are installed (see section Installing and Running)

First, navigate to the easy_sync directory with the following command: `cd easy_sync`

Now to install the necessary npm dependencies use the following command: `npm install` 
This will create a directory named node_modules with all the necessary dependencies

To create a new executable using electron run the following commands:

`npm run clean` This will ensure there isn't a previous build that could cause a conflict

`npm run build` This will build the necessary flutter files

`npm run make` This will package the necessary files using electron

After a short wait the executable can be found in the following directories:

`s25-syncineers/easy_sync/out/easy-sync-win32-x64/` in which the file named `easy-sync.exe` can be interacted with

or

`s25-syncineers/easy_sync/out/make/zip/win32/x64/easy-sync-win32-x64-1.0.0.zip` which contains the zip file


### Running in Electron for Development
To run the application within electron for testing purposes first make sure that both NodeJS and NPM are installed (see section Installing and Running)

First, navigate to the easy_sync directory with the following command:
`cd easy_sync`

Then run the following command:

`npm run clean` This will ensure there isn't a previous build that could cause a conflict

Now to install the necessary npm dependencies use the following command:

`npm install` this will create a directory named node_modules 

To run the electron application use the following command:

`npm run full-build` this will run a script outlined in package.json and run the application

Developer tools are automatically on, if you wish to turn the feature off comment out lines 112-114 in main.js located in the easy_sync directory


### Running Directly in Flutter
After cloning the repository to your machine run the build script to load the flutter files with the following command:
`./build.sh` 

Then navigate to the easy_sync directory with the following command:
`cd easy_sync`

Then with the following command you can run the flutter project: 
`flutter run -d <Device>` or `flutter run` And select the prompted device to use
