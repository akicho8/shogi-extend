import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabOther extends SettingTabBase {
  static get define() {
    return [
      { show: true, resetable: false, component_name: "SettingButton", label: "反則",           button_name: "設定", click_handle: "illegal_setting_warn_message_handle", field_message: "↑反則の設定に辿りつけない人のための偽物のボタン", },
      { show: true, resetable: false, component_name: "SettingButton", label: "スタイル",       button_name: "設定", click_handle: "appearance_modal_open_handle",        field_message: "", },
      { show: true, resetable: false, component_name: "SettingButton", label: "アバター",       button_name: "設定", click_handle: "avatar_input_modal_open_handle",      field_message: "自分の表示キャラクターを変更する", },
      { show: true, resetable: false, component_name: "SettingButton", label: "ハンドルネーム", button_name: "変更", click_handle: "handle_name_modal_open_handle",       field_message: "入室後は変更できない", },
      { show: true, resetable: false, component_name: "SettingButton", label: "部屋名",         button_name: "変更", click_handle: "title_edit_handle",                   field_message: "部屋名は棋譜の棋戦名などに使う (この設定は他者と共有する)", },

      { key: "ai_mode_key",             show: true, resetable: true, component_name: "SettingInput", },
      { key: "pentagon_appearance_key", show: true, resetable: true, component_name: "SettingInput", },
      { key: "vibration_mode_key",      show: true, resetable: true, component_name: "SettingInput", },
    ]
  }
}
