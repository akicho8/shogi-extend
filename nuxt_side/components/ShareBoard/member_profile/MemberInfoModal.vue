<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{member_info.from_user_name}}
      span.mx-1(v-if="SB.member_is_self(member_info)")
        | (自分)

  .modal-card-body
    .table-container
      table.table.is-fullwidth.is-narrow
        tbody.is-size-7
          template(v-for="row in table_rows")
            tr(v-if="row.enabled || SB.debug_mode_p")
              th {{row.label}}
              td.is_line_break_on(:class="row.value_class")
                template(v-if="_.isFunction(row.value)")
                  | {{row.value()}}
                template(v-else)
                  | {{row.value}}
                span.mx-1(v-if="row.desc" v-text="row.desc" :class="row.desc_class")
    pre(v-if="SB.debug_mode_p")
      | {{$GX.pretty_inspect(member_info)}}
      | {{SB.users_match_record_master[member_info.from_user_name]}}
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    template(v-if="SB.debug_mode_p")
      template(v-if="SB.order_lookup_from_name(member_info.from_user_name)")
        b-button.reject_handle(@click="reject_handle" type="is-warning") 順番除外
      b-button.kick_handle(@click="kick_handle" type="is-danger") KICK
    b-button.ping_handle(@click="ping_handle" type="is-primary") PING
</template>

<script>
import dayjs from "dayjs"
import { support_child } from "../support_child.js"

export default {
  name: "MemberInfoModal",
  mixins: [support_child],
  props: {
    member_info: { type: Object, required: true, },
  },
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
    ping_handle() {
      this.SB.member_info_ping_handle(this.member_info)
    },
    reject_handle() {
      this.SB.os_member_delete(this.member_info.from_user_name)
    },
    kick_handle() {
      this.SB.user_kick(this.member_info.from_user_name)
    },
    seconds_ago(v) {
      const seconds = Math.ceil((this.$time.current_ms() - v) / 1000)
      if (seconds < 60) {
        return `${seconds}秒前`
      } else {
        return this.$time.format_diff(v)
      }
    },
  },
  computed: {
    xprofile_decorator() { return this.SB.xprofile_decorator_by_name(this.member_info.from_user_name) },
    table_rows() {
      return [
        {
          enabled: true,
          label: "勝率",
          value: this.xprofile_decorator.win_rate_inspect,
        },
        {
          enabled: true,
          label: "通信状況",
          value: this.SB.member_net_level(this.member_info),
        },
        {
          enabled: true,
          label: "接続切れ",
          value: `${this.$GX.number_floor(this.SB.member_disconnected_count_per_min(this.member_info), 2)}回/1分 計${this.member_info.ac_events_hash.disconnected || 0}回`,
        },
        {
          enabled: true,
          label: "接続",
          value: `${this.member_info.ac_events_hash.connected || 0}回 (再接続: ${this.member_info.ac_events_hash.reconnected || 0}回)`,
        },
        {
          enabled: true,
          label: "端末",
          value: this.SB.UaIconInfo.fetch(this.member_info.ua_icon_key).name,
        },
        {
          enabled: true,
          label: "生存通知",
          value: `直近${this.seconds_ago(this.member_info.performed_at)} (計${this.member_info.alive_notice_count}回)`,
        },
        {
          enabled: true,
          label: "入室日時",
          value: [
            this.$time.create(this.member_info.room_joined_at).format("HH:mm:ss"),
            `(${this.seconds_ago(this.member_info.room_joined_at)})`,
          ].join(" "),
        },
        {
          enabled: true,
          label: "役割",
          value: this.SB.member_status_label(this.member_info),
        },
        {
          enabled: true,
          label: "手番",
          value: this.SB.user_name_to_display_turns(this.member_info.from_user_name) ?? "なし",
        },
        {
          enabled: true,
          label: "次回の手番",
          value: this.SB.about_next_turn_count(this.member_info.from_user_name),
        },
        {
          enabled: true,
          label: "画面フォーカス",
          value: this.member_info.window_active_p ? "ON" : "OFF (よそ見中)",
          // desc: this.member_info.window_active_p ? null : "よそ見中",
          // desc_class: "has-text-danger",
        },
        {
          enabled: true,
          label: "情報信頼レベル",
          value: this.member_info.active_level,
        },
        {
          enabled: true,
          label: "イベント受信",
          value: `${this.member_info.ac_events_hash.received || 0}回 (リジェクト${this.member_info.ac_events_hash.rejected || 0}回)`,
        },
        {
          enabled: true,
          label: "API Version",
          value: this.member_info.SERVER_SIDE_API_VERSION,
        },
        {
          enabled: true,
          label: "Client Version",
          value: this.$config.CSR_BUILD_VERSION,
        },
        {
          enabled: true,
          label: "接続ID",
          value: this.member_info.from_connection_id,
        },
        {
          enabled: true,
          label: "セッションID",
          value: this.member_info.client_token,
        },
        {
          enabled: true,
          label: "Sカウンタ",
          value: this.member_info.from_session_counter,
        },
        {
          enabled: true,
          label: "ブラウザ",
          value: this.member_info.user_agent,
          value_class: "is-size-7",
        },
      ]
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.MemberInfoModal
  +modal_width(480px)
  th:not([align])
    white-space: nowrap
    text-align: right
    width: 1%
</style>
