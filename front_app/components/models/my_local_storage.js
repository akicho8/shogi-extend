// |-----------------+-------------------------------------------|
// | method          |                                           |
// |-----------------+-------------------------------------------|
// | set(key, value) | value はなんでもいいけど undefined はだめ |
// | lookup(key)     |                                           |
// | get(key)        | lookup の alias                           |
// | fetch(key)      |                                           |
// | remove(key)     |                                           |
// | remove_all      | 全削除                                    |
// | keys            | 主にデバッグ用                            |
// | attributes      | デバッグ用                                |
// | to_h            | attributes の alias                       |
// | core            | localStorage を返す                       |
// |-----------------+-------------------------------------------|

export class MyLocalStorage {
  static set(key, value) {
    this.core.setItem(key, JSON.stringify(value))
  }

  static lookup(key) {
    const json = this.core.getItem(key)
    if (json) {
      try {
        return JSON.parse(json)
      } catch (e) {
        const message = `${this.name}.lookup(${JSON.stringify(key)}) # => ${JSON.stringify(json)}`
        console.error(message)
        alert(message)
        console.error(e)
      }
    }
  }

  static get(key) {
    return this.lookup(key)
  }

  static fetch(key) {
    const v = this.lookup(key)
    if (!v) {
      throw new Error([
        `${this.name}.fetch(${JSON.stringify(key)}) does not match anything`,
        `keys: ${JSON.stringify(this.keys)}`,
      ].join("\n"))
    }
    return v
  }

  static get keys() {
    const keys = []
    for (let i = 0; i < this.core.length; i++) {
      keys.push(this.core.key(i))
    }
    return keys
  }

  static remove(key) {
    this.core.removeItem(key)
  }

  static get attributes() {
    return this.keys.reduce((a, key) => ({...a, [key]: this.lookup(key)}), {})
  }

  static get to_h() {
    return this.attributes
  }

  static remove_all() {
    this.core.clear()
  }

  static get core() {
    return localStorage
  }
}
