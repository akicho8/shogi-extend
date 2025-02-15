import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ThinkMarkReceiveScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "tmrs_watcher_only",
        name: "観戦者のみ",
        _if: (context, params) => context.i_am_watcher_p,
      },
      {
        key: "tmrs_watcher_with_opponent",
        name: "観戦者と対局者",
        _if: (context, params) => context.i_am_watcher_p || context.user_name_is_opponent_team_p(params.from_user_name),
      },
      {
        key: "tmrs_everyone",
        name: "つつぬけ",
        _if: (context, params) => true,
      },
    ]
  }
}
