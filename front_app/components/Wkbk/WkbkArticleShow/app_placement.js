import FixedSfenConfirmModal from "../../FixedSfenConfirmModal.vue"
import AnySourceReadModal    from "../../AnySourceReadModal.vue"

export const app_placement = {
  data() {
    return {
      sp_body: null,
      sp_viewpoint: "black", // FIXME: article.viewpoint でいいのでは？
    }
  },

  watch: {
    sp_viewpoint(v) {
      this.article.viewpoint = v
    },
  },

  methods: {
    // 棋譜の読み込みタップ時の処理
    any_source_read_handle() {
      this.sound_play("click")
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        animation: "",
        component: AnySourceReadModal,
        events: {
          "update:any_source": any_source => {
            this.sound_play("click")
            this.$axios.$post("/api/general/any_source_to.json", { any_source: any_source, to_format: "sfen" }).then(e => {
              modal_instance.close()
              if (this.sfen_parse(e.body).moves.length === 0) { // 元BODのSFEN
                // moves がないので確定
                this.toast_ok("反映しました")
                this.base_sfen_set(e.body)
                this.sp_viewpoint = "black"
              } else {
                // moves があるので局面を確定してもらう
                let default_sp_turn = this.default_sp_turn(any_source)
                if (default_sp_turn == null) {
                  default_sp_turn = e.turn_max
                }
                this.extract_confirm({
                  default_sp_body: e.body,           // KIFやURLから変換後の綺麗なSFEN
                  default_sp_turn: default_sp_turn,  // 可能であればKENTOのURL推測した手数または最大手数
                  default_sp_viewpoint: "black",
                })
              }
            })
          },
        },
      })
    },

    // https://www.kento-shogi.com/?branch=B%2A8b.9c8c.8b7c%2B.7b7c.5b8b%2B.8c7d.P%2A7e.7d6c.8b6b.6c5d.6b5b&branchFrom=120&moves=2g2f.3c3d.2f2e.2b3c.2h2f.8b2b.4i3h.3a4b.2f3f.2c2d.2e2d.2b2d.P%2A2g.5a6b.9g9f.9c9d.7i6h.6b7b.3i4h.7a8b.6i7i.8c8d.5i5h.8b8c.8h9g.7b8b.9g7e.6a7b.7e6f.4c4d.3f2f.P%2A2e.2f5f.4a5b.5f4f.4b4c.3g3f.5b6b.4h3g.6c6d.7g7f.1c1d.1g1f.6b6c.5h4h.7c7d.4h3i.8a7c.5g5f.2d2b.6h5g.2b4b.5f5e.5c5d.5e5d.4c5d.5g5f.P%2A5e.5f5e.5d5e.6f5e.S%2A4e.4f4e.4d4e.5e3c%2B.2a3c.B%2A5a.4b5b.5a3c%2B.5b5i%2B.3i2h.5i7i.N%2A5e.R%2A5i.S%2A3i.B%2A5g.S%2A4h.5g4h%2B.3g4h.5i6i%2B.5e6c%2B.7b6c.7f7e.N%2A5f.P%2A5i.5f4h%2B.3i4h.4e4f.7e7d.4f4g%2B.7d7c%2B.6c7c.3h4g.P%2A4f.4g4f.G%2A4i.P%2A7d.8c7d.N%2A8f.4i4h.8f7d.7i7d.P%2A7e.7d7e.B%2A8f.7e8f.8g8f.B%2A3i.2h1h.4h3h.R%2A5b.P%2A7b.S%2A7a.8b9c.N%2A8e.8d8e.3c6f.N%2A8d.6f3i.3h3i.B%2A8b.9c8c.8b7c%2B.7b7c.G%2A8b.8c7d.P%2A7e.7d7e.5b5e%2B.N%2A6e.P%2A7f.8d7f.G%2A6f.7e8f.6f7f.8f8g#118
    // のURLから変換するときは現在局面 118 に合わせておきたい
    // FIXME: 他の所でも使うなら現在の局面を表す手数の推測はAPI側に持っていく
    default_sp_turn(str) {
      const md = str.match(/http.*kento.*#(\d+)/)
      if (md) {
        return parseInt(md[1])
      }
      return null
    },

    base_sfen_set(from_sfen) {
      this.article_init_sfen_set(from_sfen)    // article.init_sfen に設定して正解配列クリア
      this.sp_body = from_sfen                            // CustomShogiPlayer に設定
      this.$nextTick(() => this.piece_box_piece_couns_adjust()) // 駒箱最適化
    },

    // 棋譜の読み込みタップ時の処理
    extract_confirm(props) {
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        props: props,
        animation: "",
        component: FixedSfenConfirmModal,
        events: {
          "update:submit": e => {
            // this.toast_ok("反映しました")

            this.sp_viewpoint = e.viewpoint
            this.base_sfen_set(e.from_sfen) // 初期配置の設定

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
    piece_box_piece_couns_adjust() {
      this.$refs.WkbkArticleShowPlacement?.$refs.main_sp.sp_object().mediator.piece_box_piece_couns_adjust()
    },
  },
}
