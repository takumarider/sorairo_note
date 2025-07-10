#!/usr/bin/env node

const esbuild = require('esbuild')
const path = require('path')

// esbuildの設定
const config = {
  entryPoints: [
    'app/javascript/application.js',
    'app/assets/stylesheets/application.css'
  ],
  bundle: true,
  outdir: path.join(process.cwd(), 'app/assets/builds'),
  absWorkingDir: path.join(process.cwd()),
  sourcemap: true,
  format: 'esm',
  target: 'es2020',
  plugins: [],
  define: {
    global: 'globalThis',
  },
  loader: {
    '.css': 'css',
  },
  external: ['tailwindcss'],
}

// 開発モードの場合は監視モードで実行
if (process.argv.includes('--watch')) {
  const context = await esbuild.context(config)
  await context.watch()
} else {
  await esbuild.build(config)
} 