import _ from "lodash"
import { GX } from "@/components/models/gx.js"

import AvatarInputModal from "./AvatarInputModal.vue"

export const avatar_input_modal = {
  data() {
    return {
      avatar_input_modal_instance: null,
    }
  },
  mounted() {
    this.__avatar_hard_validation_process()
  },
  beforeDestroy() {
    this.avatar_input_modal_close()
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    avatar_input_modal_open_handle() {
      if (this.avatar_input_modal_instance == null) {
        this.sfx_click()
        this.sidebar_close()
        this.avatar_input_modal_open()
      }
    },
    avatar_input_modal_close_handle() {
      if (this.avatar_input_modal_instance) {
        this.sfx_click()
        this.avatar_input_modal_close()
      }
    },
    avatar_input_modal_open() {
      if (this.avatar_input_modal_instance == null) {
        this.toast_primary("アバターを入力するか選択しよう")
        this.avatar_input_modal_instance = this.modal_card_open({
          component: AvatarInputModal,
          onCancel: () => this.avatar_input_modal_close(),
        })
      }
    },
    avatar_input_modal_close() {
      if (this.avatar_input_modal_instance) {
        this.avatar_input_modal_instance.close()
        this.avatar_input_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // str に絵文字が含まれるなら、最初に現れる絵文字に対応する SVG URL を返す
    // それが取れなかった場合は現在の (SVG またはプロフ画像の) URL を返す
    avatar_preview_image_url(str) {
      let record = null
      record ??= this.avatar_char_to_avatar_record(str)
      record ??= this.__name_to_selfie(this.user_name)
      record ??= this.__name_to_animal(this.user_name)
      if (record) {
        return record.url
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    avatar_input_modal_validate_and_save(str) {
      GX.assert_kind_of_string(str)
      if (this.user_selected_avatar === str) {
        this.toast_primary(`変更はありません`)
        this.avatar_input_modal_close()
        return
      }
      if (str === "") {
        this.app_log({subject: "アバター設定", body: ["消去", this.user_selected_avatar]})
        this.user_selected_avatar_clear()
        this.toast_primary(`消しました`)
        this.avatar_input_modal_close()
        return
      }
      const info = this.AvatarSupport.validate_message(str)
      if (info && info.type === "is-danger") {
        this.app_log({subject: "アバター設定", body: ["失敗", str, info]})
        this.toast_danger(info.message)
        return
      }
      this.user_selected_avatar_safe_set(str)
      this.toast_primary(`設定しました`)
      this.app_log({subject: "アバター設定", body: ["許可", this.user_selected_avatar]})
      this.avatar_input_modal_close()
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 予約絵文字の利用時には消去し修正を促す
    __avatar_hard_validation_process() {
      if (this.avatar_hard_validation) {
        if (GX.present_p(this.user_selected_avatar)) {
          if (!this.AvatarSupport.available_char_p(this.user_selected_avatar)) {
            this.user_selected_avatar = ""
            this.avatar_input_modal_open_handle()
          }
        }
      }
    },
  },
}
