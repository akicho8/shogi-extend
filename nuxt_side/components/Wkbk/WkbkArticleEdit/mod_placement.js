import SfenTrimModal from "../../SfenTrimModal.vue"
import KifuReadModal from "../../KifuReadModal.vue"
import { KentoUrlParser } from "@/components/models/kento_url_parser.js"

export const mod_placement = {
  data() {
    return {
      sp_body: null,
    }
  },

  methods: {
    // 棋譜の読み込みタップ時の処理
    any_source_read_handle() {
      this.sfx_click()
      const modal_instance = this.modal_card_open({
        component: KifuReadModal,
        events: {
          "update:any_source": any_source => {
            this.sfx_click()
            this.$axios.$post("/api/general/any_source_to.json", { any_source: any_source, to_format: "sfen" }).then(e => {
              this.bs_error_message_dialog(e)
              if (e.body) {
                modal_instance.close()
                if (this.sfen_parse(e.body).moves.length === 0) { // 元BODのSFEN
                  // moves がないので確定
                  this.toast_primary("反映しました")
                  this.base_sfen_set(e.body)
                  // this.viewpoint = "black"
                } else {
                  // moves があるので局面を確定してもらう
                  let default_sp_turn = KentoUrlParser.parse(any_source).turn_guess
                  if (default_sp_turn == null) {
                    default_sp_turn = e.turn_max
                  }
                  this.sfen_trim_modal_handle({
                    default_sp_body: e.body,           // KIFやURLから変換後の綺麗なSFEN
                    default_sp_turn: default_sp_turn,  // 可能であればKENTOのURL推測した手数または最大手数
                  })
                }
              }
            })
          },
        },
      })
    },

    base_sfen_set(base_sfen) {
      this.article_init_sfen_set(base_sfen)    // article.init_sfen に設定して正解配列クリア
      this.sp_body = base_sfen                            // CustomShogiPlayer に設定
      this.$nextTick(() => this.piece_box_piece_counts_adjust$()) // 駒箱最適化
    },

    // 棋譜の読み込みタップ時の処理
    sfen_trim_modal_handle(props) {
      const modal_instance = this.modal_card_open({
        component: SfenTrimModal,
        props: props,
        events: {
          "update:apply": e => {
            // this.toast_primary("反映しました")

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
    piece_box_piece_counts_adjust$() {
      this.$refs.WkbkArticleEditPlacement?.$refs.main_sp.sp_object().xcontainer.piece_box_piece_counts_adjust$()
    },
  },
}
