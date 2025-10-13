import { MyLocalStorage } from "@/components/models/my_local_storage.js"
import _ from "lodash"
import { GX } from "@/components/models/gx.js"

export const mod_storage = {
  methods: {
    qs_ls_load() {
      this.persistence_form_parts.forEach(form_part => {
        const ls_sync = form_part["ls_sync"]
        if (ls_sync) {
          GX.assert(_.isPlainObject(ls_sync), "_.isPlainObject(ls_sync)") // 複雑さを避けるためハッシュのみとしてすべて明示する
          GX.assert(["if_default_is_nil", "force", "skip"].includes(ls_sync.loader), "ls_sync.loader の値が不正")
          let v = null
          if (ls_sync.global_key) {
            v = MyLocalStorage.get(ls_sync.global_key)
          } else {
            GX.assert(ls_sync.parent_key, "ls_sync.parent_key")
            GX.assert(ls_sync.child_key, "ls_sync.child_key")
            v = MyLocalStorage.hash_get(ls_sync.parent_key, ls_sync.child_key)
          }
          if (v != null) {
            const form_value = this.attributes[form_part["key"]]
            if (ls_sync.loader === "if_default_is_nil") {
              if (form_value == null) {
                this.$set(this.attributes, form_part["key"], v)
              }
            } else if (ls_sync.loader === "force") {
              this.$set(this.attributes, form_part["key"], v)
            }
          }
        }
      })
    },
    qs_ls_save() {
      this.persistence_form_parts.forEach(form_part => {
        const ls_sync = form_part["ls_sync"]
        if (ls_sync) {
          GX.assert(_.isPlainObject(ls_sync), "_.isPlainObject(ls_sync)")
          GX.assert(["force", "skip"].includes(ls_sync.writer), "ls_sync.writer の値が不正")
          const v = this.attributes[form_part["key"]]
          if (ls_sync.writer === "force") {
            if (ls_sync.global_key) {
              MyLocalStorage.set(ls_sync.global_key, v)
            } else {
              GX.assert(ls_sync.parent_key, "ls_sync.parent_key")
              GX.assert(ls_sync.child_key, "ls_sync.child_key")
              MyLocalStorage.hash_update(ls_sync.parent_key, ls_sync.child_key, v)
            }
          }
        }
      })
    },
  },
  computed: {
    persistence_form_parts() { return this.params["form_parts"].filter(e => e["ls_sync"]) },
  },
}
