import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ThinkMarkReceiveScopeInfo extends ApplicationMemoryRecord {
  static field_label = "対局中に思考印が見える人"
  static message = null
  static hint_messages = ["副ボタンまたは右上の鉛筆マークをONにすると盤の升目に印をつけることができます"]

  static get define() {
    return [
      {
        key: "tmrs_watcher_only",
        name: "観戦者のみ",
        type: "is-primary",
        message: "対局者の印は観戦者にだけ見えます (推奨)",
        environment: ["development", "staging", "production"],
        _if: (context, params) => context.i_am_watcher_p,
      },
      {
        key: "tmrs_watcher_with_opponent",
        name: "対局相手を含む",
        type: "is-warning",
        message: "対局者の印が対局相手にも見えます (指導対局向け)",
        environment: ["development", "staging", "production"],
        _if: (context, params) => context.i_am_watcher_p || context.user_name_is_opponent_team_p(params.from_user_name),
      },
      {
        key: "tmrs_everyone",
        name: "全員",
        type: "is-danger",
        message: "全員が口出しできる感じです (危険)",
        environment: ["development", "staging", "production"],
        _if: (context, params) => true,
      },
    ]
  }
}
