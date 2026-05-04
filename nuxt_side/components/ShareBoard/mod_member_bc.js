// メンバー情報のブロードキャスト関連

import { IntervalRunner } from '@/components/models/interval_runner.js'

export const mod_member_bc = {
  data() {
    return {
      member_bc_interval_runner: null, // 定期実行用
    }
  },
  beforeDestroy() {
    this.member_bc_destroy()
  },
  methods: {
    member_bc_create() {
      if (this.member_bc_interval_runner == null) {
        if (this.ALIVE_NOTIFY_INTERVAL > 0) {
          this.member_bc_interval_runner = new IntervalRunner(this.member_bc_callback, {
            name: "メンバー情報通知",
            early: true,
            interval: this.ALIVE_NOTIFY_INTERVAL,
          })
        }
      }
    },
    member_bc_destroy() {
      if (this.member_bc_interval_runner) {
        this.member_bc_stop()
        this.member_bc_interval_runner = null
      }
    },

    // インターバル実行の再スタートで即座にメンバー情報を反映する
    // 即座に member_bc_callback を実行する
    member_bc_restart() {
      if (this.member_bc_interval_runner) {
        this.member_bc_interval_runner.restart()
      }
    },

    member_bc_stop() {
      if (this.member_bc_interval_runner) {
        this.member_bc_interval_runner.stop()
      }
    },

    // 定期実行
    member_bc_callback() {
      this.member_info_share()
    },
  },
  computed: {
    ALIVE_NOTIFY_INTERVAL() { return this.param_to_f("ALIVE_NOTIFY_INTERVAL", this.AppConfig.ALIVE_NOTIFY_INTERVAL) },

    member_bc_status() {
      if (this.member_bc_interval_runner) {
        if (this.member_bc_interval_runner.id) {
          return `動作中(ID:${this.member_bc_interval_runner.id})`
        } else {
          return "停止"
        }
      } else {
        return "不在"
      }
    },
  },
}
