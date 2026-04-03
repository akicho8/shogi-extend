import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabOther extends SettingTabBase {
  static get define() {
    return [
      { show: true, resetable: false, component_name: "SettingButton", label: "盤の反転",       button_name: "する", click_handle: "how_to_half_turn_message_handle",       field_message: "↑反転の方法がわからない人のための偽物のボタン", },
      { show: true, resetable: false, component_name: "SettingButton", label: "反則",           button_name: "設定", click_handle: "how_to_illegal_setting_message_handle", field_message: "↑反則の設定に辿りつけない人のための偽物のボタン", },
      { show: true, resetable: false, component_name: "SettingButton", label: "スタイル",       button_name: "設定", click_handle: "appearance_modal_open_handle",          field_message: "盤の大きさなどを変更する", },
      { show: true, resetable: false, component_name: "SettingButton", label: "アバター",       button_name: "設定", click_handle: "avatar_input_modal_open_handle",        field_message: "自分の表示キャラクターを変更する", },
      { show: true, resetable: false, component_name: "SettingButton", label: "ハンドルネーム", button_name: "変更", click_handle: "handle_name_modal_open_handle",         field_message: "入室後は変更できない", },
      { show: true, resetable: false, component_name: "SettingButton", label: "部屋名",         button_name: "変更", click_handle: "title_edit_handle",                     field_message: "部屋名は棋譜の棋戦名などに使う (この設定は他者と共有する)", },
    ]
  }
}
