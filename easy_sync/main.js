const { app, BrowserWindow, Menu } = require('electron');
const path = require('path');
const http = require('http');
const finalhandler = require('finalhandler');
const serveStatic = require('serve-static');
const portfinder = require('portfinder');
const fs = require('fs');

const menuTemplate = require('./menu.js'); // import menu template

const isDev = process.env.NODE_ENV === 'development' || !app.isPackaged;

let mainWindow = null;
let httpServer = null;
const PORT = 7357;

async function startLocalServer() {
  try {
    let webBuildPath;
    
    if (isDev) {
      webBuildPath = path.join(__dirname, 'build', 'web');
    } else {
      const possiblePaths = [
        path.join(__dirname, 'build', 'web'),
        path.join(process.resourcesPath, 'build', 'web'),
        path.join(app.getAppPath(), 'build', 'web'),
        path.join(__dirname, '..', 'build', 'web')
      ];
      
      webBuildPath = possiblePaths.find(p => fs.existsSync(p));
      
      if (!webBuildPath) {
        throw new Error('Could not find Flutter web build directory');
      }
    }
    
    console.log(`Using web build at: ${webBuildPath}`);
    
    if (!fs.existsSync(path.join(webBuildPath, 'index.html'))) {
      throw new Error('index.html not found in web build directory');
    }
    
    // configure the static file server
    const serve = serveStatic(webBuildPath);
    
    // use specified port
    portfinder.basePort = PORT;
    const port = await portfinder.getPortPromise();
    
    // Create HTTP server
    httpServer = http.createServer((req, res) => {
      serve(req, res, finalhandler(req, res));
    });
    
    return new Promise((resolve, reject) => {
      httpServer.listen(port, '127.0.0.1', (err) => {
        if (err) {
          reject(err);
        } else {
          console.log(`HTTP server running at http://localhost:${port}`);
          resolve(port);
        }
      });
      
      httpServer.on('error', (err) => {
        reject(err);
      });
    });
  } catch (err) {
    console.error('Failed to start server:', err);
    throw err;
  }
}

// Create the main application window
async function createWindow() {
  try {
    // start local server 
    const port = await startLocalServer();
    
    mainWindow = new BrowserWindow({
      width: 1000,
      height: 800,
      icon: path.join(__dirname, 'web', 'favicon.png'),
      webPreferences: {
        nodeIntegration: false,
        contextIsolation: true
      },
      show: false 
    });
    
    // load the app
    const url = `http://localhost:${port}`;
    console.log(`Loading application from: ${url}`);
    
    mainWindow.loadURL(url);
    
    mainWindow.once('ready-to-show', () => {
      mainWindow.show();
    });
    
    // Open DevTools if in development
    if (isDev) {
      mainWindow.webContents.openDevTools();
    }
    
    mainWindow.on('closed', () => {
      mainWindow = null;
    });
  } catch (err) {
    console.error('Error in createWindow:', err);
    app.quit();
  }
}

// App ready event
app.whenReady().then(() => {
  createWindow();

  // set custom application menu
  const menu = Menu.buildFromTemplate(menuTemplate);
  Menu.setApplicationMenu(menu);
  
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// cleanup
app.on('quit', () => {
  if (httpServer) {
    httpServer.close();
    httpServer = null;
  }
});

process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
});