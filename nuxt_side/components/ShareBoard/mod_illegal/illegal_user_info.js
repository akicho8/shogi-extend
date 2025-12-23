import { GX } from "@/components/models/gx.js"
import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class IllegalUserInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "self",
        name: "当事者",
        modal_body_message: null,
        resign_click_message: null,
        blocked_message: (context, params) => `${context.user_call_name(params.selected_by)}が自分の反則を揉み消しました`,
      },
      {
        key: "my_team",
        name: "仲間",
        modal_body_message: (context)      => `${context.my_call_name}は仲間なので投了も待ったもできます`,
        resign_click_message: null,
        blocked_message: (context, params) => `${context.user_call_name(params.selected_by)}が仲間の反則を揉み消しました`,
      },
      {
        key: "op_team",
        name: "対戦者",
        modal_body_message: (context)      => `${context.my_call_name}は「待ったする」で反則をなかったことにできます`,
        resign_click_message: (context)    => `${context.my_call_name}は対戦相手なので投了できません`,
        blocked_message: (context, params) => `${context.user_call_name(params.selected_by)}がお情けで反則をなかったことにしました`,
      },
      {
        key: "watcher",
        name: "観戦者",
        modal_body_message: (context)      => `${context.my_call_name}は観戦者ですが「待ったする」で反則をなかったことにできます`,
        resign_click_message: (context)    => `${context.my_call_name}は観戦者なので投了できません`,
        blocked_message: (context, params) => `${context.user_call_name(params.selected_by)}が反則をなかったことにしました`,
      },
    ]
  }
}
