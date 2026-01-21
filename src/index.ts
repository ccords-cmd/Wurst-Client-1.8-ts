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
    const mod = await import('../packages/modules/sample/index.js');
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
