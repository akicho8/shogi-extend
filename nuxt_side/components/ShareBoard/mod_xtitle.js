import { GX } from "@/components/models/gx.js"

export const mod_xtitle = {
  data() {
    return {
      current_title: this.config.record.title, // 現在のタイトル
    }
  },
  methods: {
    current_title_set(title) {
      this.tl_p(`--> current_title_set("${title}")`)
      title = _.trim(title)
      if (this.current_title != title) {
        this.tl_p(`current_title = "${title}"`)
        this.current_title = title
        this.room_name_share()
      }
    },
    title_edit_handle() {
      this.sidebar_close()
      this.sfx_click()
      this.dialog_prompt({
        title: "タイトル",
        confirmText: "更新",
        inputAttrs: { type: "text", value: this.current_title, required: false },
        onConfirm: value => {
          this.sfx_click()
          this.current_title_set(value)
        },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_name_share() {
      this.ac_room_perform("room_name_share", this.room_name_share_dto)
    },
    room_name_share_broadcasted(params) {
      this.room_name_share_dto_receive(params)
      this.al_add({...params, label: "部屋名変更"})
      this.toast_primary(`${this.user_call_name(params.from_user_name)}が部屋名を${params.room_name}に変更しました`)
    },
    room_name_share_dto_receive(params) {
      GX.assert(params)
      GX.assert("room_name" in params)
      this.tl_p(`room_name_share_dto_receive: current_title = "${params.room_name}" from ${params.from_user_name}`)
      this.current_title = params.room_name
      this.ac_log({subject: "部屋名変更", body: `部屋名 "${this.current_title}" を受信`})
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
    room_name_share_dto() {
      return {
        room_name: this.current_title,
      }
    },
    page_title() {
      if (this.current_turn === 0) {
        return this.current_title
      } else {
        return `${this.current_title} ${this.current_turn}手目`
      }
    },
  },
}
