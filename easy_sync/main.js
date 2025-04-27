const { app, BrowserWindow } = require('electron');
const path = require('path');
const http = require('http');
const finalhandler = require('finalhandler');
const serveStatic = require('serve-static');
const portfinder = require('portfinder');
const fs = require('fs');

// Check if we're in development or production
const isDev = process.env.NODE_ENV === 'development' || !app.isPackaged;

// Global references
let mainWindow = null;
let httpServer = null;
const PORT = 7357;

// Start the server with the Flutter web build
async function startLocalServer() {
  try {
    // Determine the correct path to the web build
    let webBuildPath;
    
    if (isDev) {
      // In development, use the build/web directory
      webBuildPath = path.join(__dirname, 'build', 'web');
    } else {
      // In production, the build/web folder should be part of the app resources
      // Check a few possible locations
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
    
    // Check that index.html exists
    if (!fs.existsSync(path.join(webBuildPath, 'index.html'))) {
      throw new Error('index.html not found in web build directory');
    }
    
    // Configure the static file server
    const serve = serveStatic(webBuildPath);
    
    // Try to use the preferred port or find an available one
    portfinder.basePort = PORT;
    const port = await portfinder.getPortPromise();
    
    // Create HTTP server
    httpServer = http.createServer((req, res) => {
      serve(req, res, finalhandler(req, res));
    });
    
    // Start the server
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
    // Start local server first
    const port = await startLocalServer();
    
    // Create the browser window
    mainWindow = new BrowserWindow({
      width: 1000,
      height: 800,
      icon: path.join(__dirname, 'web', 'favicon.png'),
      webPreferences: {
        nodeIntegration: false,
        contextIsolation: true
      },
      show: false // Don't show until loaded
    });
    
    // Load the app
    const url = `http://localhost:${port}`;
    console.log(`Loading application from: ${url}`);
    
    mainWindow.loadURL(url);
    
    // Show window when ready
    mainWindow.once('ready-to-show', () => {
      mainWindow.show();
    });
    
    // Open DevTools in development
    if (isDev) {
      mainWindow.webContents.openDevTools();
    }
    
    // Handle window closed event
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
  
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

// Quit when all windows are closed
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// Cleanup on app quit
app.on('quit', () => {
  if (httpServer) {
    httpServer.close();
    httpServer = null;
  }
});

// Handle unhandled errors
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
});