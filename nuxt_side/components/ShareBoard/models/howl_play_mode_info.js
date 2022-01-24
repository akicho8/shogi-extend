import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class HowlPlayModeInfo extends ApplicationMemoryRecord {
  static field_label = "サウンドは○○を使って再生する*"
  static field_message = ""

  static get define() {
    return [
      { key: "web_audio_api", name: "Web Audio API", type: "is-primary", message: "一般的で優れた方法。初期値。おばさんの声にならない。PCであればこれ一択で良い", },
      { key: "html5_audio",   name: "HTML5 Audio",   type: "is-danger",  message: "時代遅れの方法。おばさんの声になる。スマホで音が出ないときこれにすると音が出るとの噂があったりなかったりする", },
    ]
  }
}
