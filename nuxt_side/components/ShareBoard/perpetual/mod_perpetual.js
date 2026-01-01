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
          if (this.cc_play_p) {
            // 対局中
            if (this.foul_mode_info.perpetual_check_mode === "immediately_lose") {
              // 反則したら負けのとき
              return illegal_hv
            }
            if (this.foul_mode_info.perpetual_check_mode === "show_warning") {
              // 反則しても待ったできるとき
              this.al_share({label: illegal_hv.illegal_info.name, label_type: "is-danger", full_message: this.perpetual_check_warn_message, duration_sec: 10, __standalone_mode__: true})

              // TODO: 本当ならここのロジックを sp から呼べるように fn をわたして sp 側で判定処理させる
            }
          } else {
            // 検討中
            this.sfx_play("x")
            this.al_share({label: illegal_hv.illegal_info.name, label_type: "is-danger", __standalone_mode__: true})
          }

        } else {
          // 千日手

          if (this.cc_play_p) {
            // 対局中
            if (this.foul_mode_info.perpetual_mode === "show_warning") {
              this.al_share({label: "千日手", label_type: "is-danger", full_message: this.perpetual_warn_message, duration_sec: 10, __standalone_mode__: true})
            }
          } else {
            // 検討中
            this.sfx_play("x")
            this.al_share({label: "千日手", label_type: "is-danger", __standalone_mode__: true})
          }

        }
      }
      this.perpetual_cop.increment$(key)
    },
  },

  computed: {
    perpetual_check_warn_message() {
      return [
        `本来であれば「連続王手の千日手」で${this.my_call_name}の反則負けです`,
        `次から指し手を変えてください`,
      ]
    },
    perpetual_warn_message() {
      return [
        `本来であれば「千日手」で引き分けです`,
        `どちらかが指し手を変えてください`,
      ]
    },
  },
}
