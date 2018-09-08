import MemoryRecord from 'js-memory-record'

export default class CpuBrainInfo extends MemoryRecord {
  static get define() {
    return js_cpu_battle.cpu_brain_infos
  }
}
