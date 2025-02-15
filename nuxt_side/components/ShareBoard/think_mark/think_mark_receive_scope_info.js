import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ThinkMarkReceiveScopeInfo extends ApplicationMemoryRecord {
  static field_label = "読み筋マークが見える人"
  static message = null
  static hint_messages = ["誰でも右上のペンを有効にすれば盤面に印をつけることができ、それを誰が見えるかの設定になる"]

  static get define() {
    return [
      {
        key: "tmrs_watcher_only",
        name: "観戦者のみ",
        type: "is-primary",
        message: "観戦者だけに自分の読み筋を伝えることができる (推奨)",
        environment: ["development", "staging", "production"],
        _if: (context, params) => context.i_am_watcher_p,
      },
      {
        key: "tmrs_watcher_with_opponent",
        name: "対局者を含む",
        type: "is-warning",
        message: "対局相手にも自分の読み筋を伝えることができる (接待向け)",
        environment: ["development", "staging", "production"],
        _if: (context, params) => context.i_am_watcher_p || context.user_name_is_opponent_team_p(params.from_user_name),
      },
      {
        key: "tmrs_everyone",
        name: "全員",
        type: "is-danger",
        message: "リアル対局で全員が口出ししている状態になる (危険)",
        environment: ["development", "staging", "production"],
        _if: (context, params) => true,
      },
    ]
  }
}
