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
        console.log(`migrate ${e.version}`)
        if (e.version > this.migrate_version) {
          console.log(`migrate 実行 ${e.version}`)
          e.up(this)
          this.migrate_version = e.version
        }
      })
    },
  },
  computed: {
    MigrateInfo() { return MigrateInfo },
  },
}
