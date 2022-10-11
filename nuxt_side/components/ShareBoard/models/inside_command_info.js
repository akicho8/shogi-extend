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
    ]
  }
}
