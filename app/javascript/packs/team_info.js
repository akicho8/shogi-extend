import MemoryRecord from 'js-memory-record'

class TeamInfo extends MemoryRecord {
  static get define() {
    return js_global.team_infos
  }
}

export { TeamInfo }
