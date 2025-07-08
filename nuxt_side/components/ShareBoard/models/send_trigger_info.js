import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SendTriggerInfo extends ApplicationMemoryRecord {
  static field_label = "チャットの発言の送信方法"
  static field_message = "チャットの発言をどのキーで送信できるようにするか？"

  static get define() {
    return [
      { key: "send_trigger_enter",      name: "ENTER",            type: "is-primary", message: "ENTERキーで送信する",                      talk_message: null,                  },
      { key: "send_trigger_meta_enter", name: "装飾キー + ENTER", type: "is-primary", message: "SHIFTキーなどを押しながらENTERで送信する", talk_message: "装飾キープラスENTER", },
      { key: "send_trigger_none",       name: "なし",             type: "is-primary", message: "送信ボタンのみで送信する",                 talk_message: null,                  },
    ]
  }
}
