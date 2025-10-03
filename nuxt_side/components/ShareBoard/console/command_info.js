// |---------------------|
// | /help               |
// | /test               |
// | /ping               |
// | /echo               |
// | /send               |
// | /var                |
// | /debug              |
// | /gpt content        |
// | /header             |
// |---------------------|

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

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
          return context[args[0]](...Gs.ary_drop(args, 1))
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
        desc: "localStorage 関連全リセット",
        key: "reset",
        example: "/reset",
        command_fn: (context, args) => {
          if (!context.debug_mode_p) {
            return
          }
          context.pc_data_reset()
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
        desc: "GPT に発言促す",
        key: "gpt",
        example: "/gpt content",
        command_fn: (context, args) => {
          context.ai_something_say({content: args[0]})
        },
      },
      {
        desc: "バッジ情報の確認",
        key: "xbadge",
        example: "/xbadge",
        command_fn: (context, args) => {
          return JSON.stringify(context.xbadge_counts_hash)
        },
      },
      {
        desc: "指定の人を退出させる",
        key: "kick",
        example: "/kick alice",
        command_fn: (context, args) => {
          context.user_kick(args[0])
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
        desc: "開始",
        key: "対局中",
        example: "/対局中",
        preformat: true,
        command_fn: (context, args) => {
          if (!context.debug_mode_p) {
            return
          }
          if (Gs.blank_p(context.room_key)) {
            context.room_key = "test_room"
          }
          if (Gs.blank_p(context.user_name)) {
            context.user_name = "alice"
          }
          if (Gs.blank_p(context.ac_room)) {
            context.room_create()
          }
          context.os_setup_by_names(["alice"])
          context.order_unit.state_switch_to("to_o1_state")
          // if (!context.order_enable_p) {
          //   context.order_unit.state_switch_to("to_o1_state")
          //   context.order_switch_share({order_enable_p: true})
          // }
          // if (Gs.blank_p(context.clock_box)) {
          context.cc_params = [{ initial_main_min: 60, initial_read_sec: 15, initial_extra_min: 10, every_plus: 5 }]
          context.cc_create()
          context.cc_params_apply()
          context.clock_box.play_handle()
          // }
        },
      },
    ]
  }
}
