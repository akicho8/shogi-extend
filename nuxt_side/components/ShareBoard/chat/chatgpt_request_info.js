import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs2 } from "../../models/gs2.js"
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
          return `${name}に短い言葉で元気よくユニークな挨拶をしてください`
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
            const teams = Location.values.map(location => {
              const members = context.visible_member_groups[location.key] || [] // order_enable_p が有効なときにしか取れないので注意
              const names = members.map(e => context.user_call_name(e.from_user_name))
              const names_str = names.join("と")
              // return `${names_str}の${location.name}チーム`
              // return `${names_str}チーム`
              return `${names_str}`
            }).join("対")
            return `${teams}の対局が開始されました。短い言葉で盛り上げてください`
          }
        },
      },
      {
        key: "局面にコメントする",
        command_fn: (context, params) => {
          if (params.turn === 20) {
            return `現在は${params.turn}手目です。面白おかしく戦型や囲いを短い言葉で評価してください`
          }
          if (params.turn === 50) {
            return `現在は${params.turn}手目です。中盤戦を面白おかしく短い言葉で盛り上げてください`
          }
          if (params.turn === 80) {
            return `現在は${params.turn}手目です。終盤戦を短い言葉で熱く盛り上げてください`
          }
        },
      },
      {
        key: "反則した人を励ます",
        command_fn: (context, params) => {
          const illegal_names = params.lmi.illegal_names.join("と")
          const name = context.user_call_name(params.from_user_name)
          return `反則の${illegal_names}をしてしまい落ち込んでいる${name}を短かい言葉で励ましてください`
        },
      },
      {
        key: "時間切れで負けた人を励ます",
        command_fn: (context, params) => {
          const name = context.user_call_name(params.from_user_name)
          return `時間切れで負けた${name}を短い言葉で励ましてください`
        },
      },
      {
        key: "見応えのある対局だったと褒める",
        command_fn: (context, params) => {
          if (context.self_vs_self_p) {
            return
          }
          if (context.one_vs_one_p) {
            return "対局が終わったところです。両者を短い言葉で労ってください"
          }
          if (context.many_vs_many_p) {
            const members = context.visible_member_groups[params.win_location_key]
            const names = members.map(e => context.user_call_name(e.from_user_name))
            const name = _.sample(names)
            const messages = []
            messages.push("対局が終わったところです")
            if (names.length >= 2) {
              messages.push(`とくに${name}の活躍が目立ちました`)
            }
            messages.push("短い言葉で熱く両者を労ってください")
            return messages.join("。")
          }
        },
      },
    ]
  }
}
