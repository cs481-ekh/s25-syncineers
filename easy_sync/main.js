const { app, BrowserWindow } = require('electron');
const path = require('path');


function createWindow() {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: false
    }
  });

  // Load the Flutter web app served on localhost:7357
   win.loadURL('http://localhost:7357');
//    const flutterAppPath = path.join(__dirname, 'build/web/index.html');
 // win.loadFile(flutterAppPath);
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

