import { Gs } from "@/components/models/gs.js"

export class SimpleCache {
  constructor() {
    this.cache = {}
  }

  fetch(key, block = () => {}) {
    Gs.assert(key != null, "key != null")
    if (this.exist_p(key)) {
      return this.read(key)
    }
    this.write(key, block())
    return this.read(key)
  }

  write(key, value) {
    Gs.assert(key != null, "key != null")
    this.cache[key] = value
  }

  read(key) {
    Gs.assert(key != null, "key != null")
    return this.cache[key]
  }

  delete(key) {
    Gs.assert(key != null, "key != null")
    delete this.cache[key]
  }

  // key in this.cache で判定する方法は逆に扱いにくいため値で判定する
  exist_p(key) {
    Gs.assert(key != null, "key != null")
    return this.read(key) != null
  }
}
