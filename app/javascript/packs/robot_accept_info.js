import MemoryRecord from 'js-memory-record'

export default class RobotAcceptInfo extends MemoryRecord {
  static get define() {
    return js_global.robot_accept_infos
  }
}
