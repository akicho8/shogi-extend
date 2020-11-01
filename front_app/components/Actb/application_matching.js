export const application_matching = {
  data() {
    return {
      matching_interval_timer_id: null,
      matching_interval_timer_count: null,
    }
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    matching_setup() {
      this.mode = "matching"

      this.matching_interval_timer_clear()
      this.matching_interval_timer_count = 0
      this.matching_interval_timer_processing() // 初回は待つ必要がないのですぐに呼ぶ
      this.matching_interval_timer_id = setInterval(this.matching_interval_timer_processing, 1000)
    },

    matching_interval_timer_clear() {
      if (this.matching_interval_timer_id) {
        clearInterval(this.matching_interval_timer_id)
        this.matching_interval_timer_id = null
      }
    },

    // ロビーから切断されたあともタイマーの関係で一瞬呼ばれるので mode のチェックを追加
    matching_interval_timer_processing() {
      if (this.mode === "matching") {
        if (this.matching_forgo_p) {
          this.matching_cancel_handle()
          this.warning_notice("対戦相手が見つかりません")
          return
        }
        if (this.matching_trigger_p) {
          this.matching_search()
        }
        this.matching_interval_timer_count += 1
      }
    },

    matching_search() {
      this.__assert__(this.$ac_lobby, "ロビーに接続できていない")
      this.$ac_lobby.perform("matching_search", {
        session_lock_token: this.current_user.session_lock_token,
        matching_rate_threshold: this.matching_rate_threshold,
        practice_p: this.practice_p,
      }) // --> app/channels/actb/lobby_channel.rb (matching_search)
    },
    // マッチング不成立だったりでしょっちゅう呼ばれる
    matching_user_ids_broadcasted(params) {
      this.matching_user_ids_hash = params.matching_user_ids_hash
      this.new_challenge_facade(params) // 通知関連は委譲
    },
    // session_lock_token が無効になった
    session_lock_token_invalid_narrowcasted(params) {
      if (params.session_lock_token === this.current_user.session_lock_token) {
        this.session_lock_token_invalid_notify()
        this.matching_cancel_handle()
      }
    },

    // マッチングが成立すると「ロビーにいる全員」に配信される
    // そこで自分用だと判断したときだけで部屋を作る
    // ここで問題がある
    // ロビーをPCとスマホで開いているときPCで開始するとロビーの方まで受信して二重に部屋を開いてしまう
    // その理由は「自分用だと判断」する方法が「ユーザーIDのみ」にしてしまっているから。
    // そこで session_lock_token で判断するように変更する
    room_broadcasted(params) {
      // 人間BOTでアクセスしているとき、練習で開始されたBOT用の配信を、人間BOTが受信してしまう
      // 人間ボットが受信してしまったときはスキップする
      if (params.room.bot_user_id) {
        if (params.room.bot_user_id === this.current_user.id) {
          return
        }
      }

      // const membership = params.room.memberships.find(e => e.user.id === this.current_user.id)
      const membership = params.room.memberships.find(e => e.user.actb_setting.session_lock_token === this.current_user.session_lock_token)
      if (membership) {
        this.room_setup(params.room)
      }
    },
  },

  computed: {
    matching_trigger_count()  { return Math.floor(this.matching_interval_timer_count / this.app.config.matching_interval_second)                                },
    matching_trigger_p()      { return (this.matching_interval_timer_count % this.app.config.matching_interval_second) === 0                                    },
    matching_rate_threshold() { return Math.round(Math.pow(this.app.config.matching_gap_base, this.app.config.matching_pow_base + this.matching_trigger_count)) },
    matching_forgo_p()        { return this.app.config.matching_forgo_second && (this.matching_interval_timer_count >= this.app.config.matching_forgo_second)   },
  },
}
