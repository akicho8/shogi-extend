import MemoryRecord from 'js-memory-record'

export class EditTabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "placement_mode",     name: "配置", },
      { key: "answer_create_mode", name: "正解", },
      { key: "form_mode",          name: "情報", },
      { key: "validation_mode",    name: "検証", },
    ]
  }

  // get handle_method_name() {
  //   return `${this.key}_handle`
  // }
}
