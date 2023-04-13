import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"
import { Odai } from "../fes/odai.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export class ChatgptRequestInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "参加者にあいさつする",
        command_fn: (context, params) => {
          const name = context.user_call_name(params.from_user_name)
          if (context.$route.query.__system_test_now__) { return }
          return `ちゃらい感じかつ50文字以内で${name}に元気よくユニークな挨拶をしてください`
        },
      },
      {
        key: "お題に答える",
        command_fn: (context, params) => {
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
          if (context.order_enable_p) {
            // const teams = Location.values.map(location => {
            //   const members = context.visible_member_groups[location.key] || [] // order_enable_p が有効なときにしか取れないので注意
            //   const names = members.map(e => context.user_call_name(e.from_user_name))
            //   const names_str = names.join("と")
            //   // return `${names_str}の${location.name}チーム`
            //   // return `${names_str}チーム`
            //   return `${names_str}`
            // }).join("対")
            // return `${teams}の対局が開始されました。ちゃらい感じかつ50文字以内で盛り上げてください`
            return `対局が開始されました。ちゃらい感じかつ50文字以内で盛り上げてください`
          }
        },
      },
      {
        key: "局面にコメントする",
        command_fn: (context, params) => {
          // `${params.turn}手目`
          // if (params.turn === 20) {
          //   return `序盤戦をちゃらい感じかつ50文字以内で盛り上げてください`
          // }
          // if (params.turn === 45) {
          //   return `中盤戦をちゃらい感じかつ50文字以内で盛り上げてください`
          // }
          // if (params.turn === 80) {
          //   return `終盤戦をちゃらい感じかつ50文字以内で盛り上げてください`
          // }
        },
      },
      {
        key: "反則した人を励ます",
        command_fn: (context, params) => {
          const illegal_names = params.lmi.illegal_names.join("と")
          const name = context.user_call_name(params.from_user_name)
          return `反則の${illegal_names}をしてしまい落ち込んでいる${name}をちゃらい感じかつ50文字以内で励ましてください`
        },
      },
      {
        key: "時間切れで負けた人を励ます",
        command_fn: (context, params) => {
          const name = context.user_call_name(params.from_user_name)
          return `時間切れで負けた${name}をちゃらい感じかつ50文字以内で励ましてください`
        },
      },
      {
        key: "見応えのある対局だったと褒める",
        command_fn: (context, params) => {
          if (context.self_vs_self_p) {
            return
          }
          if (context.one_vs_one_p) {
            return "対局が終わったところです。両者をちゃらい感じかつ50文字以内で労ってください"
          }
          if (context.many_vs_many_p) {
            const members = context.visible_member_groups[params.win_location_key]
            const names = members.map(e => context.user_call_name(e.from_user_name))
            const name = _.sample(names)
            const messages = []
            messages.push("対局が終わったところです。")
            if (names.length >= 2) {
              messages.push(`とくに${name}の活躍が目立ちました。`)
            }
            messages.push("ちゃらい感じかつ50文字以内で両者を労ってください。")
            return messages.join("")
          }
        },
      },
    ]
  }
}
