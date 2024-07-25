import { MyLocalStorage } from "@/components/models/my_local_storage.js"
import _ from "lodash"

export const mod_storage = {
  methods: {
    qs_ls_load() {
      this.persistence_form_parts.forEach(form_part => {
        const ls_sync = form_part["ls_sync"]
        if (ls_sync) {
          let v = null
          if (_.isPlainObject(ls_sync)) {
            // const ls_key = ls_sync["ls_key"]
            // const hv = MyLocalStorage.get(ls_key) ?? {}
            // v = hv[form_part["key"]]
            v = MyLocalStorage.hash_get(ls_sync["ls_key"], form_part["key"])
          } else {
            v = MyLocalStorage.get(form_part["key"])
          }
          if (v != null) {
            this.$set(this.attributes, form_part["key"], v)
          }
        }
      })
    },
    qs_ls_save() {
      this.persistence_form_parts.forEach(form_part => {
        const ls_sync = form_part["ls_sync"]
        if (ls_sync) {
          const v = this.attributes[form_part["key"]]
          if (_.isPlainObject(ls_sync)) {
            // const ls_key = ls_sync["ls_key"]
            // const hv = MyLocalStorage.get(ls_key) ?? {}
            // hv[form_part["key"]] = v
            // MyLocalStorage.set(ls_key, hv)
            MyLocalStorage.hash_update(ls_sync["ls_key"], form_part["key"], v)
          } else {
            MyLocalStorage.set(form_part["key"], v)
          }
        }
      })
    },
  },
  computed: {
    persistence_form_parts() { return this.params["form_parts"].filter(e => e["ls_sync"]) },
  },
}
