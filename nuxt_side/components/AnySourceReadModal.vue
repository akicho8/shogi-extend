<template lang="pug">
.modal-card
  header.modal-card-head
    p.modal-card-title.has-text-weight-bold.is-size-6
      | 棋譜の読み込み
  section.modal-card-body
    b-input(type="textarea" v-model.trim="any_source" ref="any_source" rows="6" placeholder="KIF KI2 CSA SFEN BOD の中身またはURL。KENTOや将棋DB2のSFEN風パラメータを含むURL。棋譜ファイルへのURLをコンテンツに含むサイトのURL。戦法名・囲い名などを入力してください")
  footer.modal-card-foot
    b-button(@click="cancel_handle") キャンセル
    b-button(@click="submit_handle" :type="submit_button_type") 読み込む
</template>

<script>
export default {
  name: "AnySourceReadModal",
  data() {
    return {
      any_source: "",
    }
  },
  mounted() {
    if (this.development_p) {
      if (!this.any_source) {
        this.any_source = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e"
      }
    }
    this.desktop_focus_to(this.$refs.any_source.$refs.textarea)
  },
  methods: {
    cancel_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    submit_handle() {
      this.$emit("update:any_source", this.any_source)
    },
  },
  computed: {
    submit_button_type() {
      return {
        "is-primary": (this.any_source != ""),
      }
    },
  },
}
</script>

<style lang="sass">
.AnySourceReadModal
  +modal_width(640px)
</style>
