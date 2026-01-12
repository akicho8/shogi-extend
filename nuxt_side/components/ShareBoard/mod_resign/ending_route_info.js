import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class EndingRouteInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "er_manual_normal",
        name: "投了",
        x_talk: c => `負けました`,
        t_message: null,
        m_subject: c => `終局`,
        m_body: c => `投了で${c.win_location.name}の勝ちです`,
        x_sfx_key: null,
      },
      {
        key: "er_manual_illegal",
        name: "反則からの投了",
        x_talk: c => `負けました`,
        t_message: null,
        m_subject: c => `終局`,
        m_body: c => `投了で${c.win_location.name}の勝ちです`,
        x_sfx_key: null,
      },
      {
        key: "er_auto_illegal",
        name: "反則",
        x_talk: c => c.illegal_names_str,
        t_message: null,
        m_subject: c => c.illegal_names_str,
        m_body: c => `${c.win_location.flip.name}の反則負けです`,
        x_sfx_key: "lose",
      },
      {
        key: "er_auto_checkmate",
        name: "詰み",
        x_talk: c => `詰み`,
        t_message: null,
        m_subject: c => `詰み`,
        m_body: c => `${c.win_location.name}の勝ちです`,
        x_sfx_key: null,
      },
      {
        key: "er_auto_timeout",
        name: "時間切れ",
        x_talk: null,
        t_message: null,
        m_subject: null,
        m_body: null,
        x_sfx_key: null,
      },
      {
        key: "er_auto_draw",
        name: "引き分け",
        x_talk: null,
        t_message: c => `引き分けです`,
        m_subject: null,
        m_body: null,
        x_sfx_key: null,
      },
    ]
  }
  // // 簡易的な方法でユーザーに知らせるか？
  // get toast_notify_p() {
  //   return this.notify_method_key === "toast"
  // }
  //
  // // モーダルでユーザーに知らせるか？
  // get modal_notify_p() {
  //   return this.notify_method_key === "modal"
  // }
}
