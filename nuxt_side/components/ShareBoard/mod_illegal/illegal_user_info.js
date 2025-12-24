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
        takebacked_message: (context)   => `${context.my_call_name}が自分の反則をなかったことにしました`,
      },
      {
        key: "my_team",
        name: "仲間",
        modal_body_message: (context)   => `${context.my_call_name}は仲間なので待ったできます`,
        resign_click_message: null,
        takebacked_message: (context)   => `${context.my_call_name}が仲間の反則をなかったことにしました`,
      },
      {
        key: "op_team",
        name: "対戦者",
        modal_body_message: (context)   => `${context.my_call_name}は「待った」で反則をなかったことにできます`,
        resign_click_message: (context) => `${context.my_call_name}は対戦相手なので投了できません`,
        takebacked_message: (context)   => `${context.my_call_name}がお情けで反則をなかったことにしました`,
      },
      {
        key: "watcher",
        name: "観戦者",
        modal_body_message: (context)   => `${context.my_call_name}は観戦者ですが「待った」で反則をなかったことにできます`,
        resign_click_message: (context) => `${context.my_call_name}は観戦者なので投了できません`,
        takebacked_message: (context)   => `${context.my_call_name}が反則をなかったことにしました`,
      },
    ]
  }
}
