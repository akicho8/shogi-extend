import OrderSettingModal from "./OrderSettingModal.vue"
import { StrictInfo } from "@/components/models/strict_info.js"
import _ from "lodash"
const FAKE_P = false

export const app_ordered_members = {
  data() {
    return {
      // 共有する変数
      order_func_p: false,          // 順番設定 true:有効 false:無効 モーダル内では元変数を直接変更している
      ordered_members: null,        // 出走順の実配列
      strict_key: "turn_strict_on", // 手番制限

      // ローカルのモーダルで使うテンポラリ変数
      // 「適用」してはじめて実変数に反映する
      os_table_rows:  null, // テーブル用(出走順の実配列にあとから参加した人や観戦の人を追加したテンポラリ)
      new_strict_key: null, // 手番制限
    }
  },

  created() {
    this.os_setup_by_url_params()
  },

  methods: {
    // alice bob carol dave の順番で設定する場合は
    // ordered_member_names=alice,bob,carol,dave とする
    os_setup_by_url_params() {
      const names = this.str_to_keywords(this.$route.query.ordered_member_names)
      if (this.present_p(names)) {
        this.order_func_p = true
        this.ordered_members = names.map((e, i) => ({
          enabled_p: true,
          order_index: i,
          user_name: e,
        }))
      }
    },

    // 順番設定モーダル起動
    os_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.__assert__(this.$os_modal_instance == null, "this.$os_modal_instance == null")
      this.$os_modal_instance = this.$buefy.modal.open({
        component: OrderSettingModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
          this.os_modal_close()
        },
        props: {
          base: this.base,
        },
      })
    },

    // 順番設定モーダルを閉じる
    // 別のところから強制的に閉じたいとき用
    os_modal_close() {
      if (this.$os_modal_instance) {
        this.$os_modal_instance.close()
        this.$os_modal_instance = null
        this.debug_alert("this.$os_modal_instance = null")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 順番設定モーダル内で使うデータの準備
    os_modal_vars_setup() {
      this.debug_alert("os_modal_vars_setup")
      this.os_table_rows_build()
      this.new_strict_key = this.strict_key
    },

    os_table_rows_build() {
      if (this.ordered_members == null) {
        // 最初は全員を「参加」状態で入れる
        this.os_table_rows = _.cloneDeep(this.os_table_rows_default)
      } else {
        // 1度自分で設定または他者から共有されている ordered_members を使う
        this.os_table_rows = _.cloneDeep(this.ordered_members)

        // しかし、あとから接続して来た人たちが含まれていないため「観戦」状態で追加する
        if (true) {
          this.os_table_rows_default.forEach(m => {
            if (!this.os_table_rows.some(e => e.user_name === m.user_name)) {
              this.os_table_rows.push({
                ...m,
                order_index: null,  // 順番なし
                enabled_p: false,   // 観戦
              })
            }
          })
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    ordered_members_cycle_at(index) {
      return this.ary_cycle_at(this.ordered_members, index)
    },

    // 局面 turn の手番のメンバーの名前
    user_name_by_turn(turn) {
      if (!this.order_func_p) {
        // これがないと順番設定を無効にしても ordered_members が生きていると通知されてしまう
        return null
      }
      if (this.ordered_members_blank_p) {
        return null
      }
      return this.ordered_members_cycle_at(turn).user_name
    },

    ////////////////////////////////////////////////////////////////////////////////

    order_func_share(params) {
      this.ac_room_perform("order_func_share", params) // --> app/channels/share_board/room_channel.rb
    },
    order_func_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        this.debug_alert("order_func_share 自分→自分")
      } else {
        this.debug_alert("order_func_share 自分→他者")
      }
      this.order_func_p = params.order_func_p
      if (params.message) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が順番設定を${params.message}にしました`)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    ordered_members_share(params) {
      this.ac_room_perform("ordered_members_share", params) // --> app/channels/share_board/room_channel.rb
    },
    ordered_members_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        this.debug_alert("ordered_members_share 自分→自分")
      } else {
        this.debug_alert("ordered_members_share 自分→他者")
        if (false) {
          this.os_modal_close() // もし他者が順番設定モーダルを開いていたら閉じる
        }
      }

      this.ordered_members = params.ordered_members
      this.strict_key      = params.strict_key

      // 順番設定モーダルを開いているかどうかに関係なくモーダルで使う変数を更新する
      // これは「自分→自身」でも動くので「観戦」状態の人が一番下に移動する
      if (true) {
        this.os_modal_vars_setup()
      }

      if (params.message) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が順番設定を${params.message}しました`)
      }
    },

    // 後から参加したときリクエストに答えてパラメータを送ってくれた人から受信した内容を反映する
    om_vars_copy_from(params) {
      this.__assert__("order_func_p" in params, '"order_func_p" in params')
      this.debug_alert("順番設定パラメータを先代から受信")

      this.order_func_p    = params.order_func_p
      this.ordered_members = params.ordered_members
      this.strict_key      = params.strict_key
    },
  },

  computed: {
    StrictInfo()  { return StrictInfo                                },
    strict_info() { return this.StrictInfo.fetch_if(this.strict_key) },

    // あとから接続した人に伝える内容
    om_params() {
      return {
        order_func_p:    this.order_func_p,
        ordered_members: this.ordered_members,
        strict_key:      this.strict_key,

        __nil_check_skip_keys__: "ordered_members", // 最初の状態で ordered_members は null なので nil チェックにひっかかる
      }
    },

    // モーダル用の os_table_rows の初期値
    os_table_rows_default() {
      if (this.development_p && FAKE_P) {
        return ["alice", "bob", "carol", "dave", "ellen"].map((e, i) => ({
          enabled_p: true,
          order_index: i,
          user_name: e,
        }))
      }
      return this.name_uniqued_member_infos.map((e, i) => {
        return {
          enabled_p: true,
          order_index: i,
          user_name: e.from_user_name,
        }
      })
      return v
    },

    // 参加者だけの配列
    new_ordered_members() {
      return this.os_table_rows.filter(e => e.enabled_p)
    },

    // 手番制限
    // 条件 機能ON
    // 条件 共有中のとき
    // 条件 メンバーリストが揃っている
    // 条件 手番制限ON
    // 条件 自分の手番はないとき
    sp_human_side() {
      let retv = "both"
      if (this.order_func_p) {
        if (this.ac_room) {
          // メンバーリストが揃っているなら
          // if (this.ordered_members_blank_p) {
          if (this.turn_strict_on) {
            // 手番制限なら観戦者含めて全体を「禁止」にする
            retv = "none"
            if (this.current_turn_self_p) {
              // そのあとで対象者だけを指せるようにする
              retv = "both"
            }
          }
        }
      }
      return retv
    },

    // private
    ordered_members_blank_p()   { return this.blank_p(this.ordered_members)             }, // メンバーリストが空？
    ordered_members_present_p() { return this.present_p(this.ordered_members)           }, // メンバーリストがある？
    current_turn_user_name()    { return this.user_name_by_turn(this.turn_offset)       }, // 現在の局面のメンバーの名前
    current_turn_self_p()       { return this.current_turn_user_name === this.user_name }, // 現在自分の手番か？
    turn_strict_on()            { return this.strict_info.key === "turn_strict_on"      }, // 手番制限ON ?
  },
}
