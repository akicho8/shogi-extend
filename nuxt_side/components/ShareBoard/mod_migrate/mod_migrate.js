import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { MigrateInfo } from "./migrate_info.js"

export const mod_migrate = {
  mounted() {
    this.migrate_call()
  },
  methods: {
    migrate_call() {
      this.MigrateInfo.values.forEach(e => {
        if (e.version > this.migrate_version) {
          console.log(`[migrate] ${e.version} up`)
          e.up(this)
          this.migrate_version = e.version
        } else {
          console.log(`[migrate] ${e.version} skip`)
        }
      })
    },
  },
  computed: {
    MigrateInfo() { return MigrateInfo },
  },
}
