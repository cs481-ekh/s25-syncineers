![Build Status](https://github.com/cs481-ekh/s25-syncineers/actions/workflows/flutter-build.yaml/badge.svg)


# Easy Sync
BSU CS481 Capstone project template


### Installing and Running
In the sections below you will find steps to running the project in several different ways

To run the project in electron you first must install NodeJS and NPM which both can be installed through the link [here](https://nodejs.org/en/)

#### Running in Electron for Deployment
To package a new executable with electron first make sure that both NodeJS and NPM are installed (see section Installing and Running)

First, navigate to the easy_sync directory with the following command:
`cd easy_sync`

Now to install the necessary npm dependencies use the following command:
`npm install` this will create a directory named node_modules 

To create a new executable using electron run the following command:
`npm run dist` this will run a script outlined in package.json to package the application

After a short wait the executable can be found in the following directories:
`s25-syncineers/easy_sync/out/electron-easysync-win32-x64/electron-easysync.exe`
or
`s25-syncineers/easy_sync/out/make/squirrel.windows/x64/electron-easysync-1.0.0 Setup.exe`

#### Running in Electron for Development
To run the application within electron for testing purposes first make sure that both NodeJS and NPM are installed (see section Installing and Running)

First, navigate to the easy_sync directory with the following command:
`cd easy_sync`

Now to install the necessary npm dependencies use the following command:
`npm install` this will create a directory named node_modules 

To run the electron application use the following command:
`npm run full-build` this will run a script outlined in package.json and run the application

Developer tools are automatically on, if you wish to turn the feature off comment out lines 112-114 in main.js located in the easy_sync directory

#### Running Directly in Flutter
After cloning the repository to your machine run the build script to load the flutter files with the following command:
`./build.sh` 

Then navigate to the easy_sync directory with the following command:
`cd easy_sync`

Then with the following command you can run the flutter project: 
`flutter run -d <Device>` or `flutter run` And selecting the prompted device to use