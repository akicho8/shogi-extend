import { GX } from "@/components/models/gx.js"

export const mod_room_board_setup = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    // 盤面の情報を送ってほしい
    // connected のタイミングで呼ぶ
    setup_info_request() {
      this.tl_add("情報要求", `${this.user_name} -> ALL`)
      this.ac_room_perform("setup_info_request", {
      }) // --> app/channels/share_board/room_channel.rb
    },
    setup_info_request_broadcasted(params) {
      this.tl_add("情報要求受信", `${params.from_user_name} -> ${this.user_name}`, params)
      // this.tl_alert(`${this.user_call_name(params.from_user_name)}が入室しました`)
      if (this.development_p) {
        this.sfx_play("se_pon")
      }
      this.clog(`${params.from_connection_id} が要求`)
      if (this.received_from_self(params)) {
        this.clog(`自分から自分へ`)
      } else {
        this.clog("参加者に盤の状態を教えてあげる")
        this.setup_info_send({
          to_connection_id: params.from_connection_id,
          to_user_name: params.from_user_name,
        })

        // こちらも合わせた方がいい？
        this.clog("参加者はこの部屋に誰がいるのかわかってないので自分がいることも教えてあげる")
        this.member_info_share()

        // ここではもともと時計情報を送っていたが問題があった
        //
        //   1. A, B が部屋にいて A が対局時計を開いて変更中(まだブロードキャストしていない)
        //   2. 遅れてきた C が情報を要求する
        //   3. A は C に時計の情報を送る(このときAも受信するが自分自身なのでスキップするので問題にならず)
        //   4. B も C に時計の情報を送る ← ここがおかしい
        //
        // B は C に送るつもりが A にも送っている
        // そのため A は B の対局時計の情報を受信する
        // 結果としてダイアログで変更中の内容を B の持つ情報に戻されてしまう
        // 解決方法は B は C にのみ送ること
        //
        // C だけに送るのはもともとの setup_info_send でやっていること
        // this.clock_box_share() を単独で呼ぶのではなく setup_info_send に含めて時計の情報も送ればよい
        // リクエストがまとまるためコードも簡潔になる
        if (false) {
          this.clog("参加者は対局時計があることも知らないので教えてあげる")
          this.clock_box_share("cc_behavior_bug")
        }
      }
    },

    // 盤面の情報を送って欲しい人がいるので送ってあげる
    setup_info_send(params) {
      GX.assert(params.to_connection_id != null, "params.to_connection_id != null")
      GX.assert(params.to_user_name != null, "params.to_user_name != null")

      this.clog(`${params.to_user_name} に送る`)

      params = {
        ...params,                  // 送り先 to_connection_id, to_user_name
        ////////////////////////////////////////////////////////////////////////////////
        share_data_all: this.share_data_all,
        ////////////////////////////////////////////////////////////////////////////////
        active_level: this.active_level,      // 先輩度(高い方が信憑性のある情報)
      }
      this.ac_room_perform("setup_info_send", params) // --> app/channels/share_board/room_channel.rb
    },
    setup_info_send_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.clog("自分から自分へ")
      } else {
        this.clog(`${params.from_user_name} が ${params.to_user_name} 宛に送信したものを ${this.user_name} が受信`)
        if (params.to_connection_id === this.connection_id) {
          this.clog("要求した情報を受信した")
          this.clog(`先輩度比較: 相手(${params.active_level}) > 自分(${this.active_level}) --> ${params.active_level > this.active_level}`)
          if (params.active_level > this.active_level) {
            this.ac_log({subject: "情報設定", body: `${params.from_user_name}の情報を利用 (${this.active_level} < ${params.active_level})`})
            this.tl_alert("最新の状態を共有してもらった")
            this.active_level = params.active_level
            this.share_data_receive(params.share_data_all)
          } else {
            this.clog("自分より新参の情報なので反映しない")
          }
        }
      }
    },
  },
}
