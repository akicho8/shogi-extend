import AnySourceReadModal from "@/components/AnySourceReadModal.vue"
import { Gs } from "@/components/models/gs.js"

export const mod_yomikomi = {
  data() {
    return {
      yomikomi_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.yomikomi_modal_close()
  },
  methods: {
    // クリップボードから読み込む
    yomikomi_from_clipboard() {
      if (navigator.clipboard) {
        navigator.clipboard.readText().then(text => this.yomikomi_facade(text))
        return true
      }
    },

    // 部屋を作っている場合はモーダルに読み込む
    yomikomi_facade(text) {
      if (this.ac_room == null) {
        this.yomikomi_direct(text)
      } else {
        this.yomikomi_modal_open_handle(text)
      }
    },

    // 棋譜の入力タップ時の処理
    yomikomi_modal_open_handle(source = "") {
      this.sidebar_p = false
      this.$sound.play_click()
      this.yomikomi_modal_close()
      this.yomikomi_modal_instance = this.modal_card_open({
        component: AnySourceReadModal,
        props: {
          source: source,
        },
        events: {
          "update:any_source": any_source => {
            this.yomikomi_direct(any_source)
          },
        },
      })
    },

    yomikomi_modal_close() {
      if (this.yomikomi_modal_instance) {
        this.yomikomi_modal_instance.close()
        this.yomikomi_modal_instance = null
      }
    },

    // 棋譜読み込み処理
    yomikomi_direct(any_source) {
      const params = {
        any_source: any_source,
        to_format: "sfen",
      }
      this.$axios.$post("/api/general/any_source_to.json", params).then(e => {
        this.bs_error_message_dialog(e)
        if (e.body) {
          this.$sound.play_click()
          this.toast_ok("棋譜を読み込みました")
          this.al_share({label: "棋譜読込前"})

          this.current_sfen = e.body
          this.current_turn = e.turn_max // TODO: 最大手数ではなく KENTO URL から推測する default_sp_turn
          this.honpu_main_setup()           // 読み込んだ棋譜を本譜とする
          this.honpu_share()             // それを他の人に共有する

          this.viewpoint = "black"
          this.ac_log({subject: "棋譜読込", body: e.body})

          this.yomikomi_modal_close()

          // すぐ実行すると棋譜読込前より先に記録される場合があるので遅らせる
          Gs.delay_block(0.5, () => this.al_share({label: "棋譜読込後"}))
          Gs.delay_block(1.0, () => this.quick_sync(`${this.user_call_name(this.user_name)}が棋譜を読み込んで共有しました`))
        }
      })
    },
  },
}
