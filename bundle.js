// bundle.js   (CommonJS version – works with node directly)

const esbuild = require('esbuild');

const production = process.argv.includes('--prod');

esbuild.build({
  entryPoints: ['src/index.ts'],          // ← your actual main file
  bundle: true,
  outfile: 'dist/wurst-bundle.js',
  format: 'iife',                         // "Immediately Invoked Function Expression" – good for <script> tags or injection
  platform: 'browser',                    // most common for client-side Minecraft hacks
  target: ['es2020'],                     // modern enough, but compatible with many environments
  minify: production,
  sourcemap: !production,
  treeShaking: true,
  logLevel: 'info',

  // Important if your code uses Minecraft/Forge globals that shouldn't be bundled:
  // external: ['net.minecraft.*', 'forge', ...]   // add if needed

  // If you later need to expose something globally:
  // globalName: 'WurstClient',
}).catch(() => process.exit(1));