import IllegalModal from "./IllegalModal.vue"
import { GX } from "@/components/models/gx.js"

export const mod_illegal = {
  data() {
    return {
      latest_illegal_name:    null, // 初心者モードで最後に自分がした反則の日本語名(system test 用)
      illegal_modal_instance: null, // モーダルを表示中ならそのインスタンス
    }
  },

  beforeDestroy() {
    this.illegal_modal_close()
  },

  methods: {
    //////////////////////////////////////////////////////////////////////////////// 反則 = したら負け

    // 一般モードの反則チェックありで自動的に指摘するときの処理
    // 反則モーダル発動
    illegal_modal_handle(illegal_names) {
      if (GX.present_p(illegal_names)) {
        this.sfx_stop_all()
        this.sfx_play("lose") // おおげさに「ちーん」にしておく
        // const str = params.illegal_names.join("と")
        // this.toast_ng(`${str}の反則です`)
        // this.tl_alert("反則モーダル起動完了")
        // this.sfx_play("lose")         // ちーん
        this.illegal_modal_close()
        this.illegal_modal_instance = this.modal_card_open({
          component: IllegalModal,
          props: {
            illegal_names: illegal_names,
          },
          canCancel: ["button", "escape"],
          onCancel: () => {
            this.sfx_click()
            this.illegal_modal_close()
          },
        })
      }
    },

    illegal_modal_close() {
      if (this.illegal_modal_instance) {
        this.illegal_modal_instance.close()
        this.illegal_modal_instance = null
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 反則 = できない

    // 初心者モードの反則チェックありだけど反則できないときに反則したときの処理
    // ここは何もしなければ将棋ウォーズのようになる
    ev_illegal_illegal_accident(attrs) {
      this.illegal_activation(attrs.name)
    },
    illegal_activation(illegal_name) {
      this.illegal_show(illegal_name)         // 当事者には最速で知らせたいのでブロードキャスト前にする
      this.illegal_share(illegal_name)        // 共有する
      this.ac_log({subject: "反則ブロック", body: {"種類": illegal_name, "局面": this.current_url}})
    },
    illegal_share(illegal_name) {
      this.ac_room_perform("illegal_share", {illegal_name: illegal_name}) // --> app/channels/share_board/room_channel.rb
    },
    illegal_share_broadcasted(params) {
      if (this.received_from_self(params)) {
      } else {
        this.illegal_show(params.illegal_name)
      }
      this.al_add({...params, label: params.illegal_name, label_type: "is-danger"})
    },
    illegal_show(illegal_name) {
      this.sfx_play("x")
      this.toast_ng(illegal_name)
      this.latest_illegal_name = illegal_name // デバッグ用
    },
  },
}
