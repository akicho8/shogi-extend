// チャット発言送信

import { CommandInfo } from "./command_info.js"
import { GX } from "@/components/models/gs.js"
import _ from "lodash"

export const mod_console = {
  methods: {
    func_add(a, b) {
      return a + b
    },

    console_command_run(params) {
      if (params.content.startsWith("/")) {
        this.ml_puts(params.content)
        let str = params.content
        str = str.replace(/^./, "")
        str = str.trim()
        const args = GX.str_split(str)
        const command = args.shift()
        const info = CommandInfo.lookup(command)
        if (info == null) {
          this.ml_bot_puts("command not found")
        } else {
          let value = null
          try {
            value = info.command_fn(this, args)
          } catch (e) {
            console.error(e)
            value = e
          }
          if (value != null) {
            value = this.__console_result_valus_as_string(info, value)
            this.ml_bot_puts(value)
          }
        }
        return "break"
      }
    },

    // private

    __console_result_valus_as_string(info, value) {
      if (!_.isString(value)) {
        value = GX.short_inspect(value)
      }
      if (info.preformat) {
        value = `<pre>${value}</pre>`
      } else {
        value = GX.str_simple_format(value)
      }
      return value
    },
  },
}
