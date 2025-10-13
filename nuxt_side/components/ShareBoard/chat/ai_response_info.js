import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"
import { Odai } from "../fes/odai.js"
import { Location } from "shogi-player/components/models/location.js"
import { MessageRecord } from "./message_record.js"
import _ from "lodash"

export class AiResponseInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "参加者にあいさつする",
        command_fn: (context, params) => {
          const name = context.user_call_name(params.from_user_name)
          if (context.__SYSTEM_TEST_RUNNING__) { return }
          // return `${name}に元気よくユニークな挨拶をしてください。`
        },
      },
      {
        key: "お題に答える",
        command_fn: (context, params) => {
          return

          const odai = Odai.create(params.odai)
          if (odai.invalid_p) {
            return
          }
          return odai.to_s
        },
      },
      {
        key: "対局を盛り上げる",
        command_fn: (context, params) => {
          return

          if (!context.order_enable_p) {
            return `対局が開始されました。盛り上げてください。`
          } else {
            if (true) {
              return `対局が開始されました。簡潔に短い言葉で盛り上げてください。`
            }
            if (false) {
              const teams = Location.values.map(location => {
                const members = context.visible_member_groups[location.key] || [] // order_enable_p が有効なときにしか取れないので注意
                const names = members.map(e => context.user_call_name(e.from_user_name))
                const names_str = names.join("と、")
                return `${names_str}チーム`
              }).join("対")
              return `${teams}の対局が開始されました。観戦者の立場で特定の人を応援したり、将棋の嘘の格言を(嘘とバレないように)一言添えたりして、自由に盛り上げてください。`
            }
            if (false) {
              if (context.versus_member_infos) {
                const member_info = _.sample(context.versus_member_infos)
                if (member_info) {
                  const call_name = context.user_call_name(member_info.from_user_name)
                  return `対局が開始されました。${call_name}に将棋の嘘の格言を(嘘とバレないように)アドバイスしてください。`
                }
              }
            }
          }
        },
      },
      {
        key: "局面にコメントする",
        command_fn: (context, params) => {
          // `${params.turn}手目`
          // if (params.turn === 20) {
          //   return `序盤戦を盛り上げてください`
          // }
          // if (params.turn === 45) {
          //   return `中盤戦を盛り上げてください`
          // }
          // if (params.turn === 80) {
          //   return `終盤戦を盛り上げてください`
          // }
        },
      },
      {
        key: "反則した人を励ます",
        command_fn: (context, params) => {
          const illegal_names = params.illegal_names.join("と")
          const name = context.user_call_name(params.from_user_name)
          return `反則の${illegal_names}をしてしまい落ち込んでいる${name}を励ましてな。`
        },
      },
      {
        key: "時間切れで負けた人を励ます",
        command_fn: (context, params) => {
          const name = context.user_call_name(params.from_user_name)
          return `時間切れで負けた${name}を励ましてな。`
        },
      },
      {
        key: "見応えのある対局だったと褒める",
        command_fn: (context, params) => {
          if (context.self_vs_self_p) {
            return
          }
          if (context.one_vs_one_p) {
            return
            // return "対局が終わったところです。両者を労ってください。"
          }
          if (context.many_vs_many_p) {
            const members = context.visible_member_groups[params.win_location_key]
            const names = members.map(e => context.user_call_name(e.from_user_name))
            const name = _.sample(names)
            const messages = []
            if (names.length >= 1) {
              messages.push("対局が終わったところです。")
              messages.push(`とくに${name}の活躍が目立ちました。`)
              messages.push("全角40文字以内で労ってください。")
              // messages.push("いろんなバリエーションで頼むぞ。") // ← この指示をすると、たまに、いろんな10個ぐらいパターンを列挙してくるので危険。
              return messages.join("")
            }
          }
        },
      },
      // {
      //   key: "チャットでたまに発言する",
      //   command_fn: (context, params) => {
      //     const message_record = MessageRecord.create(params)
      //     content.ai_something_say({content: "", message_scope_key: message_record.message_scope_info.key})
      //   },
      // },
      {
        key: "チャット荒らしに怒る",
        command_fn: (context, message_record) => {
          return

          const name = context.user_call_name(message_record.from_user_name)
          return `チャットを荒らしている${name}に一言。`
        },
      },
    ]
  }
}
