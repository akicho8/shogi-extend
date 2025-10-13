import KifuReadModal from "@/components/KifuReadModal.vue"
import { GX } from "@/components/models/gx.js"

export const mod_kifu_read = {
  data() {
    return {
      kifu_read_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.kifu_read_modal_close()
  },
  methods: {
    // クリップボードから読み込む
    async kifu_read_from_clipboard() {
      if (navigator.clipboard) {
        const text = await navigator.clipboard.readText()
        this.kifu_read_modal_open_or_direct_handle(text)
        return true
      }
    },

    // 部屋を作っている場合はモーダルに読み込む
    kifu_read_modal_open_or_direct_handle(text) {
      if (this.ac_room == null) {
        this.kifu_read_direct_handle(text)
      } else {
        this.kifu_read_modal_open_handle(text)
      }
    },

    // 棋譜の入力タップ時の処理
    kifu_read_modal_open_handle(source = "") {
      if (this.kifu_read_modal_instance === null) {
        this.sidebar_p = false
        this.sfx_click()
        this.kifu_read_modal_open(source)
      }
    },

    kifu_read_modal_open(source = "") {
      if (this.kifu_read_modal_instance === null) {
        this.kifu_read_modal_instance = this.modal_card_open({
          component: KifuReadModal,
          props: {
            source: source,
          },
          events: {
            "update:any_source": any_source => {
              this.kifu_read_direct_handle(any_source)
            },
            "close": () => this.kifu_read_modal_close(),
          },
          onCancel: () => {
            this.sfx_click()
            this.kifu_read_modal_close()
          },
        })
      }
    },

    kifu_read_modal_close() {
      if (this.kifu_read_modal_instance) {
        this.kifu_read_modal_instance.close()
        this.kifu_read_modal_instance = null
      }
    },

    // 棋譜読み込み処理
    kifu_read_direct_handle(any_source) {
      const params = {
        any_source: any_source,
        to_format: "sfen",
      }
      this.$axios.$post("/api/general/any_source_to.json", params).then(e => {
        this.bs_error_message_dialog(e)
        if (e.body) {
          this.sfx_click()
          this.toast_ok("棋譜を読み込みました")
          this.al_share({label: "棋譜読込前"})

          this.current_sfen = e.body
          this.current_turn = e.turn_max // TODO: 最大手数ではなく KENTO URL から推測する default_sp_turn
          this.honpu_main_setup()           // 読み込んだ棋譜を本譜とする
          this.honpu_share()             // それを他の人に共有する

          this.viewpoint = "black"
          this.ac_log({subject: "棋譜読込", body: e.body})

          this.kifu_read_modal_close()

          // すぐ実行すると棋譜読込前より先に記録される場合があるので遅らせる
          GX.delay_block(0.5, () => this.al_share({label: "棋譜読込後"}))
          GX.delay_block(1.0, () => this.quick_sync(`${this.user_call_name(this.user_name)}が棋譜を読み込んで共有しました`))
        }
      })
    },
  },
}
