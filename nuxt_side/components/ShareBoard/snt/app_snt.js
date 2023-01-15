import SntModal from "./SntModal.vue"

const SNT_MAX = 2

export const app_snt = {
  data() {
    return {
      snt_counts_hash: {},
      snt_modal_instance: null, // モーダルを表示中ならそのインスタンス
    }
  },

  beforeDestroy() {
    this.snt_modal_close()
  },

  methods: {
    // 0手目のときに呼ぶ
    snt_reset() {
      this.snt_counts_hash = {}
    },

    // 同一局面になった回数をカウント
    snt_update(e) {
      const key = e.snapshot_hash
      this.snt_counts_hash[key] = (this.snt_counts_hash[key] ?? 0) + 1
    },

    // 千日手になった？
    snt_p(e) {
      return this.snt_counts_hash[e.snapshot_hash] >= SNT_MAX
    },

    // モーダル発動
    snt_modal_handle(snt_p) {
      if (snt_p) {
        this.$sound.play("lose")  // おおげさに「ちーん」にしておく
        this.snt_modal_close()
        this.snt_modal_instance = this.modal_card_open({
          component: SntModal,
          props: {},
          onCancel: () => {
            this.$sound.play_click()
            this.snt_modal_close()
          },
        })
      }
    },

    snt_modal_close() {
      if (this.snt_modal_instance) {
        this.snt_modal_instance.close()
        this.snt_modal_instance = null
      }
    },
  },
}
