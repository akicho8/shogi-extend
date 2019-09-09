import MemoryRecord from 'js-memory-record'

export default class XyRuleInfo extends MemoryRecord {
  static get define() {
    return js_global.xy_rule_info
  }
}
