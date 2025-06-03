import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/', // Ważne dla Spring Boot
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    rollupOptions: {
      output: {
        manualChunks: undefined,
      },
    },
  },
  server: {
    proxy: {
      '/api': 'http://localhost:8080',
      '/auth': 'http://localhost:8080',
      '/users': 'http://localhost:8080',
      '/tasks': 'http://localhost:8080',
      '/orders': 'http://localhost:8080',
      '/clients': 'http://localhost:8080',
      '/reports': 'http://localhost:8080'
    }
  }
})