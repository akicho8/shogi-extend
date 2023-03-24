import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs2 } from "../../models/gs2.js"
import { Odai } from "../fes/odai.js"
import _ from "lodash"

export class ChatgptRequestInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "お題に答える",
        command_fn: (context, params) => {
          const odai = Odai.create(params.odai)
          if (odai.invalid_p) {
            return
          }
          context.gpt_speak({message: odai.to_s})
        },
      },
      {
        key: "対局を盛り上げる",
        command_fn: (context, params) => {
          const message = `対局が開始されたので短い言葉で盛り上げてください`
          context.gpt_speak({message: message})
        },
      },
      {
        key: "局面にコメントする",
        command_fn: (context, params) => {
          if (params.turn === 20) {
            const message = `現在は${params.turn}手目です。面白おかしく戦型や囲いを評価してください`
            context.gpt_speak({message: message})
            return
          }
          if (params.turn === 50) {
            const message = `現在は${params.turn}手目です。中盤戦を面白おかしく盛り上げてください`
            context.gpt_speak({message: message})
            return
          }
          if (params.turn === 100) {
            const message = `現在は${params.turn}手目です。終盤戦を熱く盛り上げてください`
            context.gpt_speak({message: message})
            return
          }
        },
      },
      {
        key: "反則した人を励ます",
        command_fn: (context, params) => {
          const illegal_names = params.lmi.illegal_names.join("と")
          const name = context.user_call_name(params.from_user_name)
          const message = `反則の${illegal_names}をしてしまい落ち込んでいる${name}を短かい言葉で励ましてください`
          context.gpt_speak({message: message})
        },
      },
      {
        key: "時間切れで負けた人を励ます",
        command_fn: (context, params) => {
          const name = context.user_call_name(params.from_user_name)
          const message = `時間切れで負けた${name}を短い言葉で励ましてください`
          context.gpt_speak({message: message})
        },
      },
      {
        key: "見応えのある対局だったと褒める",
        command_fn: (context, params) => {
          if (context.self_vs_self_p) {
            return
          }
          if (context.one_vs_one_p) {
            const message = "対局が終わったところです。短い言葉で両者を労ってください"
            context.gpt_speak({message: message})
            return
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
            messages.push("熱い言葉で両者を労ってください")
            context.gpt_speak({message: messages.join("。")})
            return
          }
        },
      },
    ]
  }
}
