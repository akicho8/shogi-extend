import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class FoulBehaviorInfo extends ApplicationMemoryRecord {
  static field_label = "反則"
  static message = null
  static hint_messages = ["反則は「二歩」「王手放置」「駒ワープ」「死に駒」のみが対象です"]

  static get define() {
    return [
      // |----------------+-------+-------+--------------------------------------------------+--------|
      // | props          | check | break |                                                  |        |
      // |----------------+-------+-------+--------------------------------------------------+--------|
      // | リレー将棋向け | o     |       | 反則になりそうでも指させてシステム側で指摘する   | 初期値 |
      // | 上級者向け     |       |       | 反則かどうかは人が判断する                       |        |
      // | 初心者向け     | o     | o     | 反則になりそうなら emit して動作をキャンセルする |        |
      // |----------------+-------+-------+--------------------------------------------------+--------|
      { key: "is_foul_behavior_auto",   name: "できる(指摘あり)", message: "指し終わったあと自動的に指摘する(81・24風)", sp_play_mode_foul_check_p: true,  sp_play_mode_foul_break_p: false, },
      { key: "is_foul_behavior_newbie", name: "できない",         message: "初心者向けで反則できない(ウォーズ風)",       sp_play_mode_foul_check_p: true,  sp_play_mode_foul_break_p: true,  },
      { key: "is_foul_behavior_throw",  name: "できる",           message: "リアルで対面対局するのと同じ",               sp_play_mode_foul_check_p: false, sp_play_mode_foul_break_p: false, },
    ]
  }
}
