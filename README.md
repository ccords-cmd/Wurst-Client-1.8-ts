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
