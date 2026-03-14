// |----------------+-------+-------+--------------------------------------------------+--------|
// | props          | check | break |                                                  |        |
// |----------------+-------+-------+--------------------------------------------------+--------|
// | リレー将棋向け | o     |       | 反則になりそうでも指させてシステム側で指摘する   | 初期値 |
// | 初心者向け     | o     | o     | 反則になりそうなら emit して動作をキャンセルする |        |
// | 上級者向け     |       |       | 反則かどうかは人が判断する                       |        |
// |----------------+-------+-------+--------------------------------------------------+--------|

// 千日手は shogi-player の中から判定するのが難しいためシンプルに lose の場合のみ有効とする

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class FoulModeInfo extends ApplicationMemoryRecord {
  static field_label = "反則"
  static message = null
  static hint_messages = null

  static get define() {
    return [
      {
        key: "lose",
        name: "したら負け",
        message: "紳士ルール (推奨)",
        battle_start_message: "反則は即負けの紳士ルールです",
        type: "is-primary",
        sp_illegal_validate: true,
        sp_illegal_cancel: false,
        perpetual_check_mode: "immediately_lose",
        perpetual_mode: "show_warning",
        environment: ["development", "staging", "production"],
      }, {
        key: "takeback",
        name: "待ったできる",
        message: "勝手に負けてもらっちゃ困る相手と指す場合に用いる",
        battle_start_message: "反則をしても待ったできる接待用ルールです",
        type: "is-warning",
        sp_illegal_validate: true,
        sp_illegal_cancel: true,
        perpetual_check_mode: "show_warning",
        perpetual_mode: "show_warning",
        environment: ["development", "staging", "production"],
      }, {
        key: "ignore",
        name: "審判不在モード",
        message: "反則のチェックを行わない。禁じ手を指せる。指し手の正当性を保証しない。通常の対局には向かない。つまりリアル道場と同じ。",
        battle_start_message: "審判はいないので反則は各自で判断してください",
        type: "is-danger",
        sp_illegal_validate: false,
        sp_illegal_cancel: false,
        perpetual_check_mode: "ignore",
        perpetual_mode: "ignore",
        environment: ["development", "staging", "production"],
      },
    ]
  }

  get to_radio_button_css_class() {
    return `is_foul_mode_${this.key}`
  }
}
