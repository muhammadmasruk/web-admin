const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
const PORT = 8080;
const FLUTTER_PORT = 8081; // Port Flutter default

// Proxy semua request ke Flutter dev server
app.use('/', createProxyMiddleware({
  target: `http://localhost:${FLUTTER_PORT}`,
  changeOrigin: true,
  ws: true, // WebSocket support untuk hot reload
}));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server berjalan di http://0.0.0.0:${PORT}`);
  console.log(`📱 Akses dari HP: http://[IP-KOMPUTER]:${PORT}`);
});