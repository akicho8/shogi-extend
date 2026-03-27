// 当事者 A vs B と観戦者 C でつまり3つの視点を考えると3パターン
// さらに1対1とリレー将棋で2パターン
// さらに終局ルートは6パターン
// これらすべてにおいて文言を変えるとなると 3 * 2 * 6 = 36 パターン になってしまう
// またそもそも「▲の勝ち」程度の表示であったに、それには誰も文句も言わず、つまりそれで充分だった
// なのでここで36パターンも切り替える必要はない
// 3つの視点というのをやめて誰にも同じ文言を表示する

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class EndingRouteInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "er_auto_checkmate",
        name: "詰み",
        talk_content: c => `詰み`,
        toast_content: null,
        modal_show: true,
        modal_subject: c => c.subject_default,
        modal_body: c => `${c.finishing_call_name}が詰まして${c.win_team_call_name}の勝ちです`,
        sfx_key: "se_notification",
      },
      {
        key: "er_user_normal_resign",
        name: "投了",
        talk_content: c => `負けました`,
        toast_content: null,
        modal_show: true,
        modal_subject: c => c.subject_default,
        modal_body: c => `${c.resigner_call_name}の投了で${c.win_team_call_name}の勝ちです`,
        sfx_key: "se_notification",
      },
      {
        key: "er_user_illegal_resign",
        name: "反則からの投了",
        talk_content: c => `負けました`,
        toast_content: null,
        modal_show: true,
        modal_subject: c => c.subject_default,
        modal_body: c => `${c.choker_call_name}の${c.illegal_names_str}からの${c.resigner_call_name}の投了で${c.win_team_call_name}の勝ちです`,
        sfx_key: "se_notification",
      },
      {
        key: "er_auto_illegal",
        name: "反則",
        talk_content: null,
        toast_content: null,
        modal_show: true,
        modal_subject: c => c.illegal_names_str,
        modal_body: c => `${c.choker_call_name}の反則で${c.win_team_call_name}の勝ちです`,
        sfx_key: "lose",
      },
      {
        key: "er_self_timeout",
        name: "時間切れ",
        talk_content: null,
        toast_content: null,
        modal_show: false,
        modal_subject: c => c.subject_default,
        modal_body: c => `${c.choker_call_name}の時間切れで${c.win_team_call_name}の勝ちです`,
        sfx_key: "lose",
      },
      {
        key: "er_disconnect",
        name: "切断",
        talk_content: null,
        toast_content: null,
        modal_show: true,
        modal_subject: c => c.subject_default,
        modal_body: c => `${c.choker_call_name}の通信不調で${c.win_team_call_name}の勝ちです`,
        sfx_key: "lose",
      },
      {
        key: "er_auto_draw",
        name: "引き分け",
        talk_content: null,
        toast_content: c => `引き分けです`,
        modal_show: true,
        modal_subject: c => c.subject_default,
        modal_body: c => `引き分けです`,
        sfx_key: "se_notification",
      },
    ]
  }
}
