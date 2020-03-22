// Example.
//
//   import MemoryRecord from "./memory_record"
//
//   class Foo extends MemoryRecord {
//     static get define() {
//       return [
//         { key: "black", name: '☗', },
//         { key: "white", name: '☖', },
//       ]
//     }
//
//     get flip() {
//       return Foo.values[(this.code + 1) % Foo.values.length]
//     }
//   }
//
//   Foo.lookup("black").key           // => "black"
//   Foo.lookup(1).key                 // => "white"
//   Foo.values[0] === Foo.values[0]   // => true
//

import _ from "lodash"

export default class LsCop {
  constructor(key) {
    this.key = key
  }

  $_ls_save() {
    if (this.development_p) {
      console.log("$_ls_save", JSON.stringify(this.$_ls_hash))
    }
    localStorage.setItem(this.ls_key, JSON.stringify(this.$_ls_hash))
  },

  $_ls_load() {
    let v = {}
    const value = localStorage.getItem(this.ls_key)
    if (value) {
      v = JSON.parse(value)
    }
    if (this.development_p) {
      console.log("$_ls_load", v)
    }
    this.$_ls_set_vars(v)
  },

  $_ls_set_vars(v) {
    this.$_ls_data_keys.forEach(e => {
      this[e] = (v[e] != null) ? v[e] : this.ls_data[e]
    })
  },

  $_ls_reset() {
    localStorage.removeItem(this.ls_key)
    this.$_ls_load()
  },

}

if (process.argv[1] === __filename) {
  class Foo extends MemoryRecord {
    static get define() {
      return [
        { key: "black", name: '☗', },
        { key: "white", name: '☖', },
        { code: 7, },
      ]
    }
  }

  console.log(Foo.keys)
  console.log(Foo.codes)

  const record = Foo.values[0]
  console.log(record.key)
  console.log(record.code)
  console.log(record.name)

  console.log(Foo.values)
  console.log(Foo.lookup("black").name)
  console.log(Foo.lookup("black").code)

  console.log(Foo.lookup("_key2").name)

  let v = Foo.lookup("black")
  console.log(v instanceof Foo)

  console.log(Foo.lookup(0))
  console.log(Foo.lookup(1))
  console.log(Foo.lookup(2))

  console.log(Foo.values[0] === Foo.values[0])

  console.log(Foo.values.map(e => e.key))
  console.log(Object.keys(Foo.keys_hash))
  console.log(Foo.fetch('unknown'))
}
