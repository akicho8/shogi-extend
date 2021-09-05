import MemoryRecord from 'js-memory-record'

export class MainSettingInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "sp_move_cancel",       model: "SpMoveCancelInfo",   },
      { key: "ctrl_mode_key",        model: "CtrlModeInfo",       },
      { key: "yomiage_mode_key",     model: "YomiageModeInfo",    },
      { key: "sp_internal_rule_key", model: "SpInternalRuleInfo", },
      { key: "debug_mode_key",       model: "DebugModeInfo",      },
    ]
  }
}
