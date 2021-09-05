import MemoryRecord from "js-memory-record"

export class BodyEncodeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "UTF-8",     message: "一般的な文字コード",                                           },
      { key: "Shift_JIS", message: "ShogiGUIでは常にこちらで、激指で連続棋譜解析するときもこちら", },
    ]
  }
}
