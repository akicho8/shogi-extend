import _ from "lodash"
import dayjs from "dayjs"

import ScsModal from "./ScsModal.vue"

export const mod_modal = {
  data() {
    return {
      // $scs_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.scs_modal_close()
  },
  methods: {
    scs_modal_handle() {
      // this.sidebar_p = false
      this.$sound.play_click()
      this.scs_modal_close()
      this.$scs_modal_instance = this.modal_card_open({
        component: ScsModal,
        // events: {
        //   "update:any_source": any_source => {
        //     this.scs_process(any_source)
        //   },
        // },
      })
    },

    scs_modal_close() {
      if (this.$scs_modal_instance) {
        this.$scs_modal_instance.close()
        this.$scs_modal_instance = null
      }
    },
  },
  computed: {
  },
}
