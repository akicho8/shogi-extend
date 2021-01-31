import { Article } from "../models/article.js"

export const app_article = {
  data() {
    return {
      article: null,
    }
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    edit_mode_snapshot_sfen(sfen) {
      if (this.article.init_sfen !== sfen) {
        if (this.article.moves_answers.length >= 1) {
          this.toast_ok("元の配置を変更したので正解を削除しました")
        }
        this.article_init_sfen_set(sfen)
      }
    },

    article_init_sfen_set(sfen) {
      this.answers_clear()
      this.article.init_sfen = sfen
      this.valid_count = 0
    },

    current_moves() {
      return this.$refs.WkbkArticleShowAnswer.$refs.main_sp.sp_object().moves_take_turn_offset
    },

    ////////////////////////////////////////////////////////////////////////////////

    play_mode_advanced_moves_set(moves) {
      // if (this.article.moves_answers.length === 0) {
      //   if (this.exam_run_count === 0) {
      //     this.toast_warn("先に正解を作ってください")
      //   }
      // }
      if (this.article.moves_valid_p(moves)) {
        this.sound_play("o")
        this.toast_ok("正解")
        // this.valid_count += 1
      }
      // this.exam_run_count += 1
    },

    turn_offset_set(v) {
      this.answer_turn_offset = v
    },
  },

  computed: {
    save_button_name()    { return this.article.new_record_p ? "保存" : "更新" },
    save_button_enabled() { return this.article.moves_answers.length >= 1      },

    //////////////////////////////////////////////////////////////////////////////// 編集権限
    owner_p()    { return this.article.owner_p(this.g_current_user) },
    editable_p() { return this.owner_p                               },
    disabled_p() { return !this.editable_p                           },
  },
}
