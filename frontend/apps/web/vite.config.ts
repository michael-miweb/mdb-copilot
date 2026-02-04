import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 45173, // Préfixe 4 pour projet MDB
  },
  preview: {
    port: 45173,
  },
  resolve: {
    alias: {
      '@mdb/shared': path.resolve(__dirname, '../../packages/shared/src'),
    },
  },
});
