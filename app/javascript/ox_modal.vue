<template lang="pug">
  b-modal.ox_modal(:active.sync="new_modal_p" trap-focus animation="" :full-screen="false" :can-cancel="['escape', 'outside']" :has-modal-card="true")
    .modal-card.is-shogi-player-modal-card
      .modal-card-body
        | OK
</template>

<script>

export default {
  name: "ox_modal",
  components: {
  },

  props: {
    // record:          {                  }, // バトル情報
  },

  data() {
    return {
      // new_modal_p: this.ox_modal_p,    // ox_modal_p の内部の値
      // run_mode: null,                  // shogi-player の現在のモード。再生モード(view_mode)と継盤モード(play_mode)を切り替える用
      // turn_offset: null,               // KENTOに渡すための手番
      // name_show_p: true,               // プレイヤーの名前を表示する？
      // time_chart_p: false,             // 時間チャートを表示する？
      // new_flip: null,                  // 上下反転している？
    }
  },

  created() {
    // // 最初から record がある場合
    // if (this.record) {
    //   this.record_setup()
    // }
  },

  watch: {
    // ox_modal_p(v)  { this.new_modal_p = v }, // 外→内 ox_modal_p --> new_modal_p
    // new_modal_p(v) {                         // 外←内 ox_modal_p <-- new_modal_p
    //   if (v) {
    //     this.chart_show_auto()
    //     this.slider_focus_delay()
    //   } else {
    //   }
    //   this.$emit("update:ox_modal_p", v)
    // },

    // // あとからレコードが渡されたとき
    // record(v) {
    //   if (v) {
    //     this.record_setup()
    //   }
    // },
  },

  methods: {
  },

  computed: {
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.ox_modal
</style>
