// |--------------------|
// | test               |
// | ping               |
// | echo               |
// | medal-team black 1 |
// | medal-user alice 1 |
// | header             |
// | help               |
// | var                |
// | debug              |
// |--------------------|

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class InsideCommandInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
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
        desc: "指定チームのメダルの増減",
        key: "medal-team",
        example: "/medal-team black 1",
        command_fn: (context, args) => {
          const location_key = args[0]
          const plus = parseInt(args[1] ?? "1")
          context.medal_add_to_team(location_key, plus)
        },
      },
      {
        desc: "指定の人のメダルの増減",
        key: "medal-user",
        example: "/medal-user alice 1",
        command_fn: (context, args) => {
          const user_name = args[0]
          const plus = parseInt(args[1] ?? "1")
          context.medal_add_to_user(user_name, plus)
        },
      },
      {
        desc: "指定の人を退出させる",
        key: "kill",
        example: "/kill alice",
        command_fn: (context, args) => {
          const user_name = args[0]
          context.user_kill(user_name)
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
      {
        desc: "ヘルプ",
        key: "help",
        example: "/help",
        preformat: true,
        command_fn: (context, args) => {
          return InsideCommandInfo.values.map(e => `${e.example}: ${e.desc}`).join("\n")
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
        preformat: true,
        command_fn: (context, args) => {
          context.debug_mode_set_any(args[0])
        },
      },
    ]
  }
}
