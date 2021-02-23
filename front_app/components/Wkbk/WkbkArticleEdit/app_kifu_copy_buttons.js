import _ from "lodash"

export const app_answer = {
  data() {
    return {
      answer_tab_index:   null, // 表示している正解タブの位置
      answer_base_turn_offset: null, // 正解モードでの手数
      answer_base_sfen:   null, // 正解作成元の盤面のSFEN
    }
  },

  methods: {
    // 正解だけを削除
    answers_clear() {
      this.$set(this.article, "moves_answers", [])
      this.answer_tab_index = 0
    },

    // 「この手順を正解とする」
    answer_create_handle() {
      this.sound_play("click")
      this.answer_create(this.current_moves())
    },

    answer_create(moves) {
      if (moves.length === 0) {
        this.toast_warn("1手以上動かしてください")
        return
      }

      // {
      //   const limit = this.config.turm_max_limit
      //   if (limit && moves.length > limit) {
      //     this.toast_warn(`${this.config.turm_max_limit}手以内にしてください`)
      //     return
      //   }
      // }

      if (this.article.moves_valid_p(moves)) {
        this.toast_warn("すでに同じ正解があります")
        return
      }

      this.article.moves_answers.push({moves_str: moves.join(" ")})
      this.$nextTick(() => this.answer_tab_index = this.article.moves_answers.length - 1)

      this.toast_ok(`${this.article.moves_answers.length}つ目の正解を追加しました`, {onend: () => {
        if (this.article.moves_answers.length === 1) {
          this.toast_ok(`他の手順で正解がある場合は続けて追加してください`)
        }
      }})
    },

    answer_delete_at(index) {
      const new_ary = this.article.moves_answers.filter((e, i) => i !== index)
      this.$set(this.article, "moves_answers", [])
      this.$nextTick(() => {
        this.$set(this.article, "moves_answers", new_ary)
        this.answer_tab_index = _.clamp(this.answer_tab_index, 0, this.article.moves_answers.length - 1)
      })

      this.sound_play("click")
      this.toast_ok("削除しました")
    },

    // PiyoShogiButton(:href="base.answer_base_piyo_shogi_app_with_params_url2(e)")
    // KentoButton(tag="a" :href="base.answer_base_kento_app_with_params_url2(e)" target="_blank")
    // KifCopyButton(@click="base.answer_base_kifu_copy_handle2(e)") コピー

    ////////////////////////////////////////////////////////////////////////////////

    answer_base_piyo_shogi_app_with_params_url2(e) {
      return this.piyo_shogi_auto_url({sfen: this.article.init_sfen_with(e), turn: 0, viewpoint: this.base.article.viewpoint})
    },
    answer_base_kento_app_with_params_url2(e) {
      return this.kento_full_url({sfen: this.article.init_sfen_with(e), turn: 0, viewpoint: this.base.article.viewpoint})
    },
    answer_base_kifu_copy_handle2(e) {
      this.sound_play("click")
      this.general_kifu_copy(this.article.init_sfen_with(e), {to_format: "kif"})
    },

    ////////////////////////////////////////////////////////////////////////////////

    answer_base_play_mode_advanced_full_moves_sfen_set(v) {
      this.answer_base_sfen = v
    },

    answer_base_kifu_copy_handle() {
      this.sound_play("click")
      this.general_kifu_copy(this.answer_base_sfen, {to_format: "kif"})
    },

  },

  computed: {
    answer_base_piyo_shogi_app_with_params_url() { return this.piyo_shogi_auto_url({sfen: this.answer_base_sfen, turn: 0, viewpoint: this.base.article.viewpoint,}) },
    answer_base_kento_app_with_params_url()      { return this.kento_full_url({sfen: this.answer_base_sfen, turn: 0, viewpoint: this.base.article.viewpoint}) },
  },
}
