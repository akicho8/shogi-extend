import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { ParamInfo } from "../models/param_info.js"

export class GeneralSettingInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      // { key: "foo_volume",           ui_component: "VolumeController",   active_var_name: "foo_active_p", },
      { key: "foo_volume",           ui_component: "SimpleRadioButtons", },
      { key: "yomiage_mode_key",     ui_component: "SimpleRadioButtons", },
      { key: "lift_cancel_action",   ui_component: "SimpleRadioButtons", },
      { key: "ctrl_mode_key",        ui_component: "SimpleRadioButtons", },
      { key: "quick_sync_key",       ui_component: "SimpleRadioButtons", },
      { key: "legal_key",            ui_component: "SimpleRadioButtons", },
      { key: "illegal_behavior_key", ui_component: "SimpleRadioButtons", },
      // { key: "auto_resign_key",   ui_component: "SimpleRadioButtons", },
      { key: "debug_mode_key",       ui_component: "SimpleRadioButtons", },
    ]
  }

  get param_info() {
    return ParamInfo.fetch(this.key)
  }
}
