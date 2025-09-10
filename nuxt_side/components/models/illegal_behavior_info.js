// |----------------+-------+-------+--------------------------------------------------+--------|
// | props          | check | break |                                                  |        |
// |----------------+-------+-------+--------------------------------------------------+--------|
// | リレー将棋向け | o     |       | 反則になりそうでも指させてシステム側で指摘する   | 初期値 |
// | 初心者向け     | o     | o     | 反則になりそうなら emit して動作をキャンセルする |        |
// | 上級者向け     |       |       | 反則かどうかは人が判断する                       |        |
// |----------------+-------+-------+--------------------------------------------------+--------|

// 千日手は shogi-player の中から判定するのが難しいためシンプルに is_illegal_behavior_auto の場合のみ有効とする

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class IllegalBehaviorInfo extends ApplicationMemoryRecord {
  static field_label = "反則"
  static message = null
  static hint_messages = ["反則は「二歩」「王手放置」「駒ワープ」「死に駒」のみが対象です。千日手は「したら負け」のときだけ指摘します。"]

  static get define() {
    return [
      {
        key: "is_illegal_behavior_auto",
        name: "したら負け",
        message: "緊張感↑ 逆転の余地↑ 盛り上がり↑ (推奨)",
        type: "is-primary",
        sp_illegal_validate: true,
        sp_illegal_cancel: false,
        perpetual_check_p: true,
        environment: ["development", "staging", "production"],
      }, {
        key: "is_illegal_behavior_newbie",
        name: "できない",
        message: "緊張感↓ 逆転の余地↓ 盛り上がり↓ (超初心者向け)",
        type: "is-warning",
        sp_illegal_validate: true,
        sp_illegal_cancel: true,
        perpetual_check_p: false,
        environment: ["development", "staging", "production"],
      }, {
        key: "is_illegal_behavior_throw",
        name: "関与しない",
        message: "リアル対局と同じで、もし二歩をしても対局は進む (非推奨)",
        type: "is-danger",
        sp_illegal_validate: false,
        sp_illegal_cancel: false,
        perpetual_check_p: false,
        environment: ["development", "staging", "production"],
      },
    ]
  }
}
