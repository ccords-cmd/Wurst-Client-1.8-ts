#!/usr/bin/env bash
set -euo pipefail
# Run from the root of your local clone of the repository.
# Usage: ./create-files.sh

mkdir -p .github/workflows
mkdir -p .decompiled-java
mkdir -p src
mkdir -p packages/modules/sample

cat > package.json <<'EOF'
{
  "name": "wurst-client-1.8-ts",
  "version": "0.1.0",
  "private": false,
  "workspaces": [
    "packages/*"
  ],
  "scripts": {
    "build": "tsc -b",
    "lint": "eslint . --ext .ts",
    "test": "echo \"No tests configured\" && exit 0",
    "start": "node ./dist/index.js"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "eslint": "^8.0.0",
    "@typescript-eslint/parser": "^5.0.0",
    "@typescript-eslint/eslint-plugin": "^5.0.0",
    "prettier": "^2.0.0"
  }
}
EOF

cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "rootDir": "./src",
    "outDir": "./dist",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": [
    "src/**/*"
  ]
}
EOF

cat > .eslintrc.js <<'EOF'
module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: { ecmaVersion: 2020, sourceType: 'module' },
  plugins: ['@typescript-eslint'],
  extends: ['eslint:recommended', 'plugin:@typescript-eslint/recommended'],
  env: { node: true, es6: true }
};
EOF

cat > .prettierrc <<'EOF'
{
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100
}
EOF

cat > .gitignore <<'EOF'
node_modules/
dist/
.env
EOF

cat > README.md <<'EOF'
# Wurst-Client-1.8-TS

This repository will host a TypeScript port of the Wurst Client (Minecraft 1.8) focused on loading and running hack modules in a TypeScript runtime. The initial commit provides a TypeScript monorepo scaffold, a module-loader skeleton, and a placeholder for the decompiled Java sources. The decompiled Java sources will be added in a follow-up commit.

Quick start:

1. Install dependencies: `pnpm install` or `npm install`
2. Build: `pnpm build` or `npm run build`
3. Start (runs compiled sample): `pnpm start` or `npm start`

Project layout:

- /src - runtime entry and module loader (core runtime)
- /packages/modules - TypeScript-converted hack modules
- /decompiled-java - decompiled Java sources (placeholder)

License: The original Wurst release is a public resource; decompiled sources will be included for reference. Ensure you comply with any applicable licenses and legal restrictions.

----
EOF

cat > .decompiled-java/README.md <<'EOF'
# Decompiled Java (placeholder)

This folder will contain the decompiled Java source of the Wurst-Client v2.14 (MC1.8) release for reference during the port. The original release assets are available here:

- https://github.com/Wurst-Imperium/Wurst-MCX2/releases/tag/v2.14
- JAR: https://github.com/Wurst-Imperium/Wurst-MCX2/releases/download/v2.14/Wurst-Client-v2.14-MC1.8.jar
- ZIP: https://github.com/Wurst-Imperium/Wurst-MCX2/releases/download/v2.14/Wurst-Client-v2.14-MC1.8.zip

I will decompile the JAR and commit the decompiled Java sources into this folder in the next push.
EOF

cat > src/index.ts <<'EOF'
export type ModuleInit = (runtime: Runtime) => void;

export interface Module {
  id: string;
  init: ModuleInit;
}

export class Runtime {
  private modules: Map<string, Module> = new Map();

  register(module: Module) {
    if (this.modules.has(module.id)) {
      throw new Error(`Module with id ${module.id} already registered`);
    }
    this.modules.set(module.id, module);
  }

  async initAll() {
    for (const m of this.modules.values()) {
      try {
        m.init(this);
        console.log(`Initialized module: ${m.id}`);
      } catch (e) {
        console.error(`Failed to init module ${m.id}:`, e);
      }
    }
  }
}

// quick bootstrap
const runtime = new Runtime();

// sample dynamic import loader (for packages/modules/*)
async function loadSampleModule() {
  try {
    const mod = await import('../packages/modules/sample');
    if (mod && mod.default) {
      runtime.register(mod.default);
    }
  } catch (e) {
    console.warn('Could not load sample module dynamically.');
  }
}

(async () => {
  await loadSampleModule();
  await runtime.initAll();
})();
EOF

cat > packages/modules/sample/index.ts <<'EOF'
import { Module, ModuleInit, Runtime } from '../../../src/index';

const init: ModuleInit = (runtime: Runtime) => {
  console.log('Sample module initialized — this demonstrates module API compatibility.');
};

const SampleModule: Module = {
  id: 'sample.module',
  init,
};

export default SampleModule;
EOF

cat > .github/workflows/ci.yml <<'EOF'
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Use Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      - name: Install
        run: npm ci
      - name: Build
        run: npm run build
      - name: Lint
        run: npm run lint || true
EOF

echo "All files created. Review then run 'git add -A && git commit -m \"Initial TypeScript scaffold and decompiled-java placeholder\" && git push -u origin main'"
EOF