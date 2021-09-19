import SfenTrimModal from "../../SfenTrimModal.vue"
import AnySourceReadModal    from "../../AnySourceReadModal.vue"

export const app_placement = {
  data() {
    return {
      sp_body: null,
    }
  },

  methods: {
    // 棋譜の読み込みタップ時の処理
    any_source_read_handle() {
      this.sound_play("click")
      const modal_instance = this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: "modal_basic AnySourceReadModal",
        component: AnySourceReadModal,
        parent: this,
        hasModalCard: true,
        animation: "",
        events: {
          "update:any_source": any_source => {
            this.sound_play("click")
            this.$axios.$post("/api/general/any_source_to.json", { any_source: any_source, to_format: "sfen" }).then(e => {
              modal_instance.close()
              if (this.sfen_parse(e.body).moves.length === 0) { // 元BODのSFEN
                // moves がないので確定
                this.toast_ok("反映しました")
                this.base_sfen_set(e.body)
                // this.sp_viewpoint = "black"
              } else {
                // moves があるので局面を確定してもらう
                let default_sp_turn = this.turn_guess(any_source)
                if (default_sp_turn == null) {
                  default_sp_turn = e.turn_max
                }
                this.sfen_trim_modal_handle({
                  default_sp_body: e.body,           // KIFやURLから変換後の綺麗なSFEN
                  default_sp_turn: default_sp_turn,  // 可能であればKENTOのURL推測した手数または最大手数
                })
              }
            })
          },
        },
      })
    },

    base_sfen_set(base_sfen) {
      this.article_init_sfen_set(base_sfen)    // article.init_sfen に設定して正解配列クリア
      this.sp_body = base_sfen                            // CustomShogiPlayer に設定
      this.$nextTick(() => this.piece_box_piece_counts_adjust()) // 駒箱最適化
    },

    // 棋譜の読み込みタップ時の処理
    sfen_trim_modal_handle(props) {
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        props: props,
        animation: "",
        component: SfenTrimModal,
        events: {
          "update:submit": e => {
            // this.toast_ok("反映しました")

            this.base.article.viewpoint = e.viewpoint
            this.base_sfen_set(e.base_sfen) // 初期配置の設定

            if (e.moves.length >= 1) {
              this.base.answer_create(e.moves)   // 正解手順があれば設定
              this.answer_tab_handle() // 「正解タブ」に移動
            }

            modal_instance.close()
          },
        },
      })
    },

    // 駒箱正規化
    piece_box_piece_counts_adjust() {
      this.$refs.WkbkArticleEditPlacement?.$refs.main_sp.sp_object().mediator.piece_box_piece_counts_adjust()
    },
  },
}
