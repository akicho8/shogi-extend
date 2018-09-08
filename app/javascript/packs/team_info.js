import MemoryRecord from 'js-memory-record'

export default class TeamInfo extends MemoryRecord {
  static get define() {
    return js_global.team_infos
  }
}
