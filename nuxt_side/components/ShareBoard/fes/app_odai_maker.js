import OdaiMakerModal from "./OdaiMakerModal.vue"
import { Odai } from "./odai.js"

export const app_odai_maker = {
  data() {
    return {
      odai_src: Odai.create(),
    }
  },
  mounted() {
    if (this.development_p) {
      this.odai_src_set()
    }
  },
  methods: {
    odai_src_clear() {
      this.odai_src = Odai.create()
    },
    odai_src_set() {
      this.odai_src = Odai.from_json({subject: "どっちがお好き？", items: ["マヨネーズ", "ケチャップ"]})
    },
    odai_modal_handle() {
      this.modal_card_open({component: OdaiMakerModal})
    },
  },
  computed: {
    Odai() { return Odai },
  },
}
