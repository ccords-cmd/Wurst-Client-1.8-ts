import { Module, ModuleInit, Runtime } from '../../../src/index';

const init: ModuleInit = (runtime: Runtime) => {
  console.log('Sample module initialized — this demonstrates module API compatibility.');
};

const SampleModule: Module = {
  id: 'sample.module',
  init,
};

export default SampleModule;
export { SampleModule } from './SampleModule';