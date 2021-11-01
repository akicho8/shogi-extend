// const it = new CycleIterator(["a", "b"])
// it.next // => "a"
// it.next // => "b"
// it.next // => "a"
//
export class CycleIterator {
  constructor(values) {
    this.values = values
    this.index = 0
  }

  get next() {
    const value = this.peek
    this.index += 1
    return value
  }

  get peek() {
    return this.values[this.position]
  }

  get size() {
    return this.values.length
  }

  get position() {
    if (this.size === 0) {
      throw new Error("iteration reached an end")
    }
    return this.index % this.size
  }
}
