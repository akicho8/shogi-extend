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
import { GX } from "@/components/models/gx.js"
import { parse as TwitterEmojiParser } from "@twemoji/parser"
import TwemojiApi from "@twemoji/api"

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
          context.toast_primary("pong")
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
          return context[args[0]](...GX.ary_drop(args, 1))
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
        desc: "アバターの設定",
        key: "avatar",
        example: "/avatar 🍣",
        command_fn: (context, args) => {
          const str = args[0]
          if (str) {
            if (context.user_selected_avatar_safe_set(str)) {
              return `"${context.user_selected_avatar}"を設定しました`
            }
          } else {
            return context.user_selected_avatar
          }
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
        key: "xprofile",
        example: "/xprofile",
        command_fn: (context, args) => {
          return JSON.stringify(context.users_match_record_master)
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
          if (GX.blank_p(context.room_key)) {
            context.room_key = "test_room"
          }
          if (GX.blank_p(context.user_name)) {
            context.user_name = "alice"
          }
          if (GX.blank_p(context.ac_room)) {
            context.room_create()
          }
          context.os_setup_by_names(["alice"])
          // if (!context.order_enable_p) {
          //   context.order_switch_share({order_enable_p: true})
          // }
          // if (GX.blank_p(context.clock_box)) {
          context.cc_params = [{ initial_main_min: 60, initial_read_sec: 15, initial_extra_min: 10, every_plus: 5 }]
          context.cc_create()
          context.cc_params_apply()
          context.clock_box.play_handle()
          // }
        },
      },

      {
        desc: "talkの同期実行",
        key: "test:talk",
        example: "/test:talk",
        command_fn: async (context, args) => {
          await context.talk("a")
          await context.talk("b")
          await context.talk("c")
        },
      },
      {
        desc: "toast_primary の同期実行",
        key: "test:toast_primary",
        example: "/test:toast_primary",
        command_fn: async (context, args) => {
          await context.toast_primary("a")
          await context.toast_primary("b")
          await context.toast_primary("c")
        },
      },
    ]
  }
}
