import { PerpetualCop } from "./perpetual_cop.js"

export const mod_perpetual = {
  data() {
    return {
      perpetual_cop: PerpetualCop.create(),
    }
  },

  methods: {
    // perpetual_cop を更新する前にチェックする
    perpetual_check_detect(e) {
      const key = [e.op_king_check, e.snapshot_hash].join(",")
      if (this.perpetual_cop.tentatively_check_p(key)) {
        if (e.op_king_check) {
          const illegal_hv = this.illegal_create_perpetual_check(e)
          if (this.foul_mode_info.perpetual_check_mode === "immediately_lose") {
            // 反則したら負けのとき
            return illegal_hv
          }
          if (this.foul_mode_info.perpetual_check_mode === "show_warning") {
            // 反則しても待ったできるとき
            this.al_share({label: illegal_hv.illegal_info.name, label_type: "is-danger", full_message: this.perpetual_check_warn_message, duration_sec: 10})

            // TODO: 本当ならここのロジックを sp から呼べるように fn をわたして sp 側で判定処理させる
          }
          if (this.foul_mode_info.perpetual_check_mode === "ignore") {
            // 関与しない
          }
        }
      }
      this.perpetual_cop.increment$(key)
    },
  },

  computed: {
    perpetual_check_warn_message() {
      return [
        `本来であれば連続王手の千日手で${this.my_call_name}の反則負けです`,
        `次から指し手を変えてください`,
      ]
    },
  },
}
