// |---------------------|
// | /help               |
// | /test               |
// | /ping               |
// | /echo               |
// | /send               |
// | /var                |
// | /debug              |
// | /medal-team black 1 |
// | /medal-user alice 1 |
// | /header             |
// |---------------------|

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CommandInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        desc: "ヘルプ",
        key: "help",
        example: "/help",
        preformat: true,
        command_fn: (context, args) => {
          return CommandInfo.values.map(e => `${e.example}: ${e.desc}`).join("\n")
        },
      },
      {
        desc: "テスト用",
        key: "test",
        example: "/test a b c",
        command_fn: (context, args) => {
          return args
        },
      },
      {
        desc: "PING",
        key: "ping",
        example: "/ping",
        command_fn: (context, args) => {
          context.toast_ok("pong")
          return "pong"
        },
      },
      {
        desc: "入力内容を表示する",
        key: "echo",
        example: "/echo abc",
        command_fn: (context, args) => {
          return args.join(" ")
        },
      },
      {
        desc: "特定のメソッドを実行",
        key: "send",
        example: "/send func_add a b c",
        command_fn: (context, args) => {
          return context[args[0]](...context.ary_drop(args, 1))
        },
      },
      {
        desc: "変数確認",
        key: "var",
        example: "/var user_name",
        preformat: true,
        command_fn: (context, args) => {
          return context[args[0]]
        },
      },
      {
        desc: "デバッグモード(引数なしでトグル)",
        key: "debug",
        example: "/debug on",
        command_fn: (context, args) => {
          context.debug_mode_set_any(args[0])
        },
      },
      {
        desc: "メダル情報の確認",
        key: "medal",
        example: "/medal",
        command_fn: (context, args) => {
          return JSON.stringify(context.medal_counts_hash)
        },
      },
      {
        desc: "指定チームのメダルの増減(部屋でのみ使用可)",
        key: "medal-team",
        example: "/medal-team black 1",
        command_fn: (context, args) => {
          context.medal_add_to_team(args[0], parseInt(args[1] ?? "1"))
        },
      },
      {
        desc: "指定の人のメダルの増減(部屋でのみ使用可)",
        key: "medal-user",
        example: "/medal-user alice 1",
        command_fn: (context, args) => {
          context.medal_add_to_user(args[0], parseInt(args[1] ?? "1"))
        },
      },
      {
        desc: "自分のメダル増減",
        key: "medal-self",
        example: "/medal-self 1",
        command_fn: (context, args) => {
          context.medal_add_to_self(parseInt(args[0] ?? "1"))
        },
      },
      {
        desc: "指定の人を退出させる",
        key: "kill",
        example: "/kill alice",
        command_fn: (context, args) => {
          context.user_kill(args[0])
        },
      },
      {
        desc: "メンバーの名前を表示",
        key: "header",
        example: "/header",
        preformat: true,
        command_fn: (context, args) => {
          return context.player_names_with_title_as_human_text
        },
      },
    ]
  }
}
