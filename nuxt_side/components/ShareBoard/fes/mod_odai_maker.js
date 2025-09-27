import OdaiMakerModal from "./OdaiMakerModal.vue"
import { Odai } from "./odai.js"
import { OdaiSampleInfo } from "./odai_sample_info.js"

export const mod_odai_maker = {
  data() {
    return {
      master_odai: Odai.create(),
    }
  },
  methods: {
    odai_src_clear() {
      this.master_odai = Odai.create()
    },
    odai_src_sample() {
      this.master_odai = Odai.sample
    },
    odai_src_random_handle() {
      this.sfx_play_click()
      const odai = OdaiSampleInfo.sample
      if (odai) {
        this.master_odai = odai
      }
    },
    odai_maker_handle() {
      this.master_odai = this.master_odai.dup() // id を更新する
      this.modal_card_open({component: OdaiMakerModal})
    },
  },
  computed: {
    Odai()             { return Odai                                                }, // SbFesPanel.vue 用
    // odai_new_p()       { return !this.odai_persisted_p                              }, // 新しいお題か？
    // odai_persisted_p() { return this.master_odai.same_content_p(this.received_odai) }, // 同じ内容か？(再送信か？)
  },
}
