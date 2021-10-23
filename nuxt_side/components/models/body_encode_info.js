import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class BodyEncodeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "UTF-8",     message: "一般的な文字コード",                                           },
      { key: "Shift_JIS", message: "ShogiGUIでは常にこちらで、激指で連続棋譜解析するときもこちら", },
    ]
  }
}
