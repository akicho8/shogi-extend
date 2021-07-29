import MemoryRecord from 'js-memory-record'

export class NetLevelInfo extends MemoryRecord {
  static get define() {
    return [
      { name: "最悪",         threshold: 0.50, },
      { name: "めっちゃ悪い", threshold: 0.40, },
      { name: "悪い",         threshold: 0.30, },
      { name: "やや悪い",     threshold: 0.20, },
      { name: "わりと良い",   threshold: 0.10, },
      { name: "とても良い",   threshold: 0.01, },
      { name: "最高に良い",   threshold: 0.00, },
    ]
  }
}
