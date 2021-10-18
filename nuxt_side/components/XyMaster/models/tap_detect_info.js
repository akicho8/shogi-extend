import MemoryRecord from 'js-memory-record'

export class TapDetectInfo extends MemoryRecord {
  // static get field_label() {
  //   return "タップを検出する方法"
  // }
  static field_label = "タップを検出する方法"

  static get define() {
    return [
      { key: "pointerdown", name: "pointerdown", message: "触れた瞬間に反応する。連打できる。おすすめ。ただしiOS15では連打できない", },
      { key: "click",       name: "click",       message: "iOS15ではこちらにすると連打できる。が、離したときにしか反応しないので結局以前のような操作感にはならない。とりあえず連打できないよりはましか", },
    ]
  }
}
