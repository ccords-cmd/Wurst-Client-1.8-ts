export interface Module {
  id: string;
  init?(): void;
  // add more later: name, category, onEnable, onDisable, etc.
}