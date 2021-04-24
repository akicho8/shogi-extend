import MemberOrderModal from "./MemberOrderModal.vue"
import { StrictInfo } from "@/components/models/strict_info.js"
import _ from "lodash"
const FAKE_P = false

export const app_member_order = {
  data() {
    return {
      // 共有する変数
      order_func_p: false,          // 順番設定 true:有効 false:無効 モーダル内では元変数を直接変更している
      ordered_members: null,        // 出走順の実配列
      strict_key: "turn_strict_on", // 手番制限

      // ローカルのモーダルで使うテンポラリ変数
      // 「適用」してはじめて実変数に反映する
      table_rows:     null, // テーブル用(出走順の実配列にあとから参加した人や観戦の人を追加したテンポラリ)
      new_strict_key: null, // 手番制限
    }
  },
  methods: {
    mo_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.__assert__(this.$mo_modal_instance == null, "this.$mo_modal_instance == null")
      this.$mo_modal_instance = this.$buefy.modal.open({
        component: MemberOrderModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
          this.mo_modal_close()
        },
        props: {
          base: this.base,
        },
      })
    },

    mo_modal_close() {
      if (this.$mo_modal_instance) {
        this.$mo_modal_instance.close()
        this.$mo_modal_instance = null
        this.debug_alert("this.$mo_modal_instance = null")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    mo_vars_update() {
      this.debug_alert("mo_vars_update")
      this.table_rows_setup()
      this.new_strict_key = this.strict_key
    },

    table_rows_setup() {
      if (this.ordered_members == null) {
        // 1度も設定されていないので全員を「参加」状態で入れる
        this.table_rows = _.cloneDeep(this.default_ordered_members)
      } else {
        // 1度自分で設定または他者から共有されている ordered_members を使う
        this.table_rows = _.cloneDeep(this.ordered_members)

        // しかし、あとから接続して来た人たちが含まれていないため「観戦」状態で追加する
        if (true) {
          this.default_ordered_members.forEach(m => {
            if (!this.table_rows.some(e => e.user_name === m.user_name)) {
              this.table_rows.push({
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
      if (this.ordered_members_blank_p) {
        return null
      }
      // if (this.ordered_members_blank_p) {
      return this.ordered_members_cycle_at(turn).user_name
      // }
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
          this.mo_modal_close() // もし他者が順番設定を開いていたら閉じる
        } else {
        }
      }

      this.ordered_members = params.ordered_members
      this.strict_key      = params.strict_key

      if (this.$mo_modal_instance) {
        this.__assert__("component" in this.$mo_modal_instance, "'component' in this.$mo_modal_instance")
        this.__assert__(this.$mo_modal_instance.component.name === "MemberOrderModal", "this.$mo_modal_instance.component.name === 'MemberOrderModal'")
        this.mo_vars_update()
      }

      if (params.message) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が順番設定を${params.message}しました`)
      }

      if (false) {
        const member = this.ordered_members.find(e => e.user_name === this.user_name)
        if (member) {
          const previous_index = this.ruby_like_modulo(member.order_index - 1, this.ordered_members.length)
          const ordered_member = this.ordered_members[previous_index]
          this.previous_user_name = ordered_member.user_name
          this.toast_ok(`${this.user_call_name(params.from_user_name)}が${this.user_call_name(this.user_name)}の手番の通知を有効にしました`)
        } else {
          this.previous_user_name = null
          this.toast_ok(`${this.user_call_name(params.from_user_name)}が${this.user_call_name(this.user_name)}の手番の通知を無効にしました`)
        }
      }
    },

    mo_vars_copy_from(params) {
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
    mo_setup_vars() {
      return {
        order_func_p:    this.order_func_p,
        ordered_members: this.ordered_members,
        strict_key:      this.strict_key,
      }
    },

    // モーダル用の table_rows の初期値
    default_ordered_members() {
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
    ordered_members_blank_p()   { return (this.ordered_members || []).length === 0      }, // メンバーリストが空？
    current_turn_user_name()    { return this.user_name_by_turn(this.turn_offset)       }, // 現在の局面のメンバーの名前
    current_turn_self_p()       { return this.current_turn_user_name === this.user_name }, // 現在自分の手番か？
    turn_strict_on()            { return this.strict_info.key === "turn_strict_on"      }, // 手番制限ON ?
  },
}
