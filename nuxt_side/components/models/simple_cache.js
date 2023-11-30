export class SimpleCache {
  constructor() {
    this.cache = {}
  }

  fetch(key, block = () => {}) {
    if (this.exist_p(key)) {
      return this.read(key)
    }
    this.write(key, block())
    return this.read(key)
  }

  write(key, value) {
    this.cache[key] = value
  }

  read(key) {
    return this.cache[key]
  }

  delete(key) {
    delete this.cache[key]
  }

  exist_p(key) {
    return key in this.cache
  }
}
