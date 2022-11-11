import { defineConfig } from "vite";
import pathLib from "path"
import { splitVendorChunkPlugin } from 'vite'

export default defineConfig({
  server:{
    host:"0.0.0.0",
    port:"8080",
    https:false
  },
  build:{
    rollupOptions:{
      input:{
        main:pathLib.resolve('./index.html'),
      },
      
      output:{
        entryFileNames: `assets/[name].js`,
        chunkFileNames: `assets/[name].js`,
        assetFileNames: `assets/[name].[ext]`
      }
    }
  },
  plugins:[
    //splitVendorChunkPlugin()
  ]
  // Uncomment to use JSX:
  // esbuild: {
  //   jsx: "transform",
  //   jsxFactory: "m",
  //   jsxFragment: "'['",
  // },
});
