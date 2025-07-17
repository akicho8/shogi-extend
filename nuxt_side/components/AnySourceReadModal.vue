<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 棋譜の入力
  .modal-card-body
    b-input(type="textarea" v-model.trim="mut_source" ref="mut_source" rows="6" :placeholder="SHARED_STRING.kifu_body_placeholder")
  .modal-card-foot
    b-button.cancel_handle(@click="cancel_handle") キャンセル
    b-button.submit_handle(@click="submit_handle" :type="submit_button_type") 読み込む
</template>

<script>
export default {
  name: "AnySourceReadModal",
  props: {
    source: { type: String, required: false, default: "", },
  },

  data() {
    return {
      mut_source: this.source,
    }
  },
  mounted() {
    if (this.development_p) {
      if (!this.mut_source) {
        this.mut_source = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e"
      }
    }
    this.desktop_focus_to(this.$refs.mut_source.$refs.textarea)
  },
  methods: {
    cancel_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    submit_handle() {
      this.$emit("update:any_source", this.mut_source)
    },
  },
  computed: {
    submit_button_type() {
      return {
        "is-primary": (this.mut_source != ""),
      }
    },
  },
}
</script>

<style lang="sass">
.AnySourceReadModal
  +modal_width(640px)
  textarea
    word-break: break-all
</style>
