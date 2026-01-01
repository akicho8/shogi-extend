import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ToastInfo extends ApplicationMemoryRecord {
  static get default_params() {
    return {
      toast: true,
      talk: true,
      queue: false,
      position: "is-bottom",
      type: "is-primary",
    }
  }

  static get define() {
    return [
      {
        key: "is_toast_screen_bottom",
        default_params: {
        },
      },
      {
        key: "is_toast_main_board_top",
        default_params: {
          position: "is-top",
          container: ".ToastMainBoard .CustomShogiPlayer .MainBoard",
        },
      },
      {
        key: "is_toast_main_board_bottom",
        default_params: {
          position: "is-bottom",
          container: ".ToastMainBoard .CustomShogiPlayer .MainBoard",
        },
      },
    ]
  }
}
