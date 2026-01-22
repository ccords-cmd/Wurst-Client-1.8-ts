import { Module } from '../../core/Module';  // adjust path

export class SampleModule implements Module {
  id = 'sample';

  init() {
    console.log('Sample module initialized');
  }
}