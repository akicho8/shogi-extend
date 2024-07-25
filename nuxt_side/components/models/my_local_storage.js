// |--------------------------------+-------------------------------------------|
// | method                         |                                           |
// |--------------------------------+-------------------------------------------|
// | hash_get(key1, key2)           | ls[key1][key2]                            |
// | hash_update(key1, key2, value) | ls[key1].update(key2, value)              |
// | set(key, value)                | value はなんでもいいけど undefined はだめ |
// | lookup(key)                    |                                           |
// | get(key)                       | lookup の alias                           |
// | fetch(key)                     |                                           |
// | remove(key)                    |                                           |
// | remove_all                     | 全削除                                    |
// | keys                           | 主にデバッグ用                            |
// | attributes                     | デバッグ用                                |
// | to_h                           | attributes の alias                       |
// | core                           | localStorage を返す                       |
// |--------------------------------+-------------------------------------------|

export class MyLocalStorage {
  //////////////////////////////////////////////////////////////////////////////// 値を Hash とした場合のショートカット

  static hash_get(key1, key2) {
    return (this.get(key1) ?? {})[key2]
  }

  static hash_update(key1, key2, value) {
    const hv = this.get(key1) ?? {}
    hv[key2] = value
    this.set(key1, hv)
  }

  ////////////////////////////////////////////////////////////////////////////////

  static set(key, value) {
    if (this.core) {
      if (this.development_p) {
        console.log(`storage.set('${key}', ${JSON.stringify(value)})`)
      }
      this.core.setItem(key, JSON.stringify(value))
    }
  }

  static lookup(key) {
    if (this.core) {
      const json = this.core.getItem(key)
      if (this.development_p) {
        console.log(`storage.get('${key}', ${json})`)
      }
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

  ////////////////////////////////////////////////////////////////////////////////

  static get keys() {
    const keys = []
    if (this.core) {
      for (let i = 0; i < this.core.length; i++) {
        keys.push(this.core.key(i))
      }
    }
    return keys
  }

  static remove(key) {
    if (this.core) {
      this.core.removeItem(key)
    }
  }

  static get attributes() {
    return this.keys.reduce((a, key) => ({...a, [key]: this.lookup(key)}), {})
  }

  static get to_h() {
    return this.attributes
  }

  static remove_all() {
    if (this.core) {
      this.core.clear()
    }
  }

  static get core() {
    return (typeof window !== 'undefined' && this.storage)
  }

  static get storage() {
    return localStorage
  }

  static get development_p() {
    return process.env.NODE_ENV === "development"
  }
}
