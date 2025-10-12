import _ from "lodash"
import dayjs from "dayjs"
import { Gs } from "@/components/models/gs.js"

export const mod_room_members = {
  data() {
    return {
      member_infos: [],         // 参加者たち
      room_joined_at:     null, // 部屋に接続した時間(ms)
      alive_notice_count: null, // 生存通知を送信した回数
    }
  },
  methods: {
    // alice bob carol dave の順番で設定する場合は
    // member_names=alice,bob,carol,dave とする
    // member_names= なら空で設定
    member_add_by_url_params() {
      this.member_add_by_names(this.fixed_member)
    },

    // ダミーをうめる
    member_add_by_names(names) {
      // const performed_at = this.$time.current_ms()
      names.forEach((name, index) => {
        const params = {
          ...this.ac_room_perform_default_params(),
          from_session_id:    index,        //
          from_session_counter: 0,          //
          from_connection_id: index,        // 送信者識別子
          from_user_name:     name,         // 名前
          performed_at:       0,            // 実行日時(ms)
          active_level:       0,            // 先輩度(高い方が信憑性のある情報)
          alive_notice_count: 0,            // 通知した回数
          room_joined_at:     index,        // 部屋に入った日時(古参比較用)
          window_active_p:    true,         // Windowの状態
          user_agent:         null,         // ブラウザ情報
        }
        if (this.user_name === name) {
          params["from_session_id"] = this.session_id
          params["from_session_counter"] = this.session_counter
          params["from_connection_id"] = this.connection_id
        }
        this.member_add(params)
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    // created, room_create, room_destroy で呼ばれる
    member_infos_init() {
      this.tl_puts("<--> member_infos_init")
      this.member_infos = []

      if (this.fixed_member_names_p) {
        this.member_add_by_url_params()
      } else {
        this.member_bc_create()
      }
    },

    member_infos_leave() {
      this.member_infos = []
    },

    // 接続するタイミングで初期化
    // room_joined_at は古参度でソートするため
    member_info_init() {
      this.tl_puts("<--> member_info_init")
      this.alive_notice_count = 0
      this.room_joined_at = this.$time.current_ms()
    },

    // 自分が存在することをみんなに伝える
    // 定期実行
    member_info_share() {
      if (!this.ac_room) {
        // alive_notice_count が変化しないようにするため
        return
      }
      if (this.fixed_member_names_p) {
        return
      }
      this.tl_alert("生存通知")
      // this.tl_add("USER", "member_info_share")
      this.alive_notice_count += 1
      this.ac_room_perform("member_info_share", {
        // この情報はそのまま member_infos に追加する
        from_session_id:     this.session_id,              // 送信者識別子
        from_session_counter:     this.session_counter,    //
        alive_notice_count:  this.alive_notice_count,      // 通知した回数
        room_joined_at:      this.room_joined_at,          // 部屋に入った日時(古参比較用)
        window_active_p:     this.window_active_p,         // Windowの状態
        user_agent:          window.navigator.userAgent,   // ブラウザ情報
        active_level:        this.active_level,            // 先輩度(高い方が信憑性のある情報)
      }) // --> app/channels/share_board/room_channel.rb
    },

    // 誰かが存在することが伝えられた
    member_info_share_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分
      } else {
        // 他の人が存在することを自分に伝えられた
      }
      if (params.alive_notice_count === 1) {
        this.room_entry_call(params)
        this.ai_say_case_hello(params)
      }
      this.member_add(params)
    },

    member_add(params) {
      this.tl_puts(`--> member_add: ${params.from_user_name}`, params)
      const size = this.member_infos.length

      this.member_infos.push(params)
      this.member_infos_normalize()

      if (this.current_member_is_leader_p) {
        if (this.member_infos.length === size) {
          // 個数変化なし
        } else {
          // 個数変化あり
          this.ac_log({subject: "仲間一覧", body: this.member_infos.map(e => e.from_user_name)})
        }
      }
      this.tl_puts(`<-- member_add: ${params.from_user_name}`, params)
    },

    // 処理順序重要
    // セッションIDはブラウザをリロードしても同じIDを返すため同じ人と判断できる
    member_infos_normalize() {
      this.member_infos = _.orderBy(this.member_infos, "performed_at", "desc")      // 情報が新しいもの順に並べてから
      // this.member_infos = _.uniqBy(this.member_infos, "from_connection_id")         // ユーザーの重複を防ぐ(新しい方を採取できる) ←分身してしまう
      this.member_infos = _.uniqBy(this.member_infos, e => [e.from_user_name, e.from_session_id].join("/")) // ユーザーの重複を防ぐ(新しい方を採取できる)←分身しない方法
      this.member_infos = this.member_infos_find_all_newest(this.member_infos)      // 通知が来た時間が最近の人だけを採取する
      this.member_infos = _.orderBy(this.member_infos, ["room_joined_at"], ["asc"]) // 上から古参順に並べる
    },

    // 通知が来た日時が最近の人だけを採取する
    member_infos_find_all_newest(list) {
      if (this.fixed_member_names_p) {
        return list
      }
      return list.filter(e => this.member_elapsed_sec(e) < this.AppConfig.KILL_SEC)
    },

    // 生きているか？
    member_alive_p(e) {
      if (this.fixed_member_names_p) {
        return true
      }
      return this.member_elapsed_sec(e) < this.AppConfig.ALIVE_SEC
    },

    // 寝ているか？
    member_is_disconnect(e) {
      if (this.$route.query.member_is_disconnect === "true") {
        return true
      }
      return !this.member_alive_p(e)
    },

    // 通達があってからの経過秒数
    member_elapsed_sec(e) {
      return (this.$time.current_ms() - e.performed_at) / 1000
    },

    // 退出
    member_reject(leave_info) {
      this.member_infos = _.reject(this.member_infos, e => e.from_connection_id === leave_info.from_connection_id)
    },
  },
  computed: {
    uniq_member_infos()    { return _.uniqBy(this.member_infos, "from_user_name") },                                // 名前でユニークにした member_infos
    room_user_names()      { return this.uniq_member_infos.map(e => e.from_user_name) },                            // ユニークな名前のリスト
    room_user_names_hash() { return this.uniq_member_infos.reduce((a, e) => ({...a, [e.from_user_name]: e}), {}) }, // 名前からO(1)で member_infos の要素を引くためのハッシュ

    // メンバーリストを固定させるか？
    fixed_member_names_p() {
      return "fixed_member" in this.$route.query
    },
    // 固定されるメンバーたち
    fixed_member() {
      if (this.fixed_member_names_p) {
        return Gs.str_to_words(this.$route.query.fixed_member)
      }
    },

    // 一番上にいる人は自分か？
    // つまり最古参メンバーか？
    current_member_is_leader_p() {
      if (Gs.present_p(this.member_infos)) {
        return this.member_infos[0].from_connection_id === this.connection_id
      }
    },
  },
}
