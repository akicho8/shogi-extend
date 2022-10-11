// |--------------------|
// | test               |
// | ping               |
// | echo               |
// | medal-team black 1 |
// | medal-user alice 1 |
// |--------------------|

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class InsideCommandInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "test",
        command_fn: (context, args) => {
          return args
        },
      },
      {
        key: "ping",
        command_fn: (context, args) => {
          context.toast_ok("pong")
          return "pong"
        },
      },
      {
        key: "echo",
        command_fn: (context, args) => {
          return args.join(" ")
        },
      },
      {
        key: "medal-team",
        example: "medal-team black 1",
        command_fn: (context, args) => {
          const location_key = args[0]
          const plus = parseInt(args[1] ?? "1")
          context.medal_plus_handle(location_key, plus)
        },
      },
      {
        key: "medal-user",
        example: "medal-user alice 1",
        command_fn: (context, args) => {
          const user_name = args[0]
          const plus = parseInt(args[1] ?? "1")
          context.medal_plus_to_user_handle(user_name, plus)
        },
      },
    ]
  }
}
