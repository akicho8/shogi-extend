import { params_controller } from "@/components/params_controller.js"

export const mod_storage = {
  mixins: [params_controller],
  methods: {
    pc_mounted() {
      this.form_setup()
    },
  },
}
