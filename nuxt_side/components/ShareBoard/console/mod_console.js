// チャット発言送信

import { CommandInfo } from "./command_info.js"
import { Gs } from "@/components/models/gs.js"
import _ from "lodash"

export const mod_console = {
  methods: {
    func_add(a, b) {
      return a + b
    },

    console_command_run(params) {
      if (params.message.startsWith("/")) {
        this.local_say(params.message)
        let str = params.message
        str = str.replace(/^./, "")
        str = str.trim()
        const args = this.str_split(str)
        const command = args.shift()
        const info = CommandInfo.lookup(command)
        if (info == null) {
          this.local_bot_say("command not found")
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
            this.local_bot_say(value)
          }
        }
        return "break"
      }
    },

    // private

    __console_result_valus_as_string(info, value) {
      if (!_.isString(value)) {
        value = Gs.short_inspect(value)
      }
      if (info.preformat) {
        value = `<pre>${value}</pre>`
      } else {
        value = this.str_simple_format(value)
      }
      return value
    },
  },
}
