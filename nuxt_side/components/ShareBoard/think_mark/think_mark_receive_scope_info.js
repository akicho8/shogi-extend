import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ThinkMarkReceiveScopeInfo extends ApplicationMemoryRecord {
  static field_label = "自動投了"
  static message = null
  static hint_messages = ["あ？"]

  static get define() {
    return [
      {
        key: "tmrs_watcher_only",
        name: "観戦者のみ",
        type: "is-primary",
        message: "A",
        environment: ["development", "staging", "production"],
        _if: (context, params) => context.i_am_watcher_p,
      },
      {
        key: "tmrs_watcher_with_opponent",
        name: "観戦者と対局者",
        type: "is-warning",
        message: "B",
        environment: ["development", "staging", "production"],
        _if: (context, params) => context.i_am_watcher_p || context.user_name_is_opponent_team_p(params.from_user_name),
      },
      {
        key: "tmrs_everyone",
        name: "つつぬけ",
        type: "is-danger",
        message: "C",
        environment: ["development", "staging", "production"],
        _if: (context, params) => true,
      },
    ]
  }
}
