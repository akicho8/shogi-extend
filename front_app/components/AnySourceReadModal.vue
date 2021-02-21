<template lang="pug">
.modal-card.AnySourceReadModal
  header.modal-card-head
    p.modal-card-title.is-size-6 棋譜の読み込み
  section.modal-card-body
    b-input(type="textarea" v-model="any_source" ref="any_source" placeholder="KIF KI2 CSA SFEN BOD の中身またはURL\nKENTOのURL, 将棋DB2のSFENが含まれるURL\n戦法名, 囲い名\nなどを入力してください")
  footer.modal-card-foot
    b-button(@click="submit_handle" type="is-primary") 読み込む
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
    submit_handle() {
      this.$emit("update:any_source", this.any_source)
    },
  },
}
</script>

<style lang="sass">
.AnySourceReadModal
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
