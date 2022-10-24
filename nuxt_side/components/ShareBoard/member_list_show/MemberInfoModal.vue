<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{member_info.from_user_name}}
      span.mx-1(v-if="TheSb.member_is_self(member_info)")
        | (自分)

  .modal-card-body
    .table-container
      table.table.is-fullwidth.is-narrow
        tbody.is-size-7
          template(v-for="row in table_rows")
            tr(v-if="row.enabled || TheSb.debug_mode_p")
              th {{row.label}}
              td.is_line_break_on(:class="row.value_class")
                template(v-if="_.isFunction(row.value)")
                  | {{row.value()}}
                template(v-else)
                  | {{row.value}}
                span.mx-1(v-if="row.desc" v-text="row.desc" :class="row.desc_class")
    pre(v-if="TheSb.debug_mode_p")
      | {{pretty_inspect(member_info)}}
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.ping_handle(@click="ping_handle" type="is-primary") PING
</template>

<script>
import { support_child } from "../support_child.js"
import dayjs from "dayjs"

export default {
  name: "MemberInfoModal",
  mixins: [support_child],
  props: {
    member_info: { type: Object, required: true, },
  },
  inject: ["TheSb"],
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    ping_handle() {
      this.TheSb.member_info_ping_handle(this.member_info)
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
    table_rows() {
      return [
        {
          enabled: true,
          label: "通信状況",
          value: this.TheSb.member_net_level(this.member_info),
        },
        {
          enabled: true,
          label: "接続切れ",
          value: `${this.number_floor(this.TheSb.member_disconnected_count_per_min(this.member_info), 2)}回/1分 計${this.member_info.ac_events_hash.disconnected || 0}回`,
        },
        {
          enabled: true,
          label: "接続",
          value: `${this.member_info.ac_events_hash.connected || 0}回`,
        },
        {
          enabled: true,
          label: "端末",
          value: this.TheSb.UaIconInfo.fetch(this.member_info.ua_icon_key).name,
        },
        {
          enabled: true,
          label: "生存通知",
          value: `直近${this.seconds_ago(this.member_info.performed_at)} 計${this.member_info.alive_notice_count}回`,
        },
        {
          enabled: true,
          label: "入室日時",
          value: [
            this.$time.create(this.member_info.room_joined_at).format("hh:mm:ss"),
            `(${this.seconds_ago(this.member_info.room_joined_at)})`,
          ].join(" "),
        },
        {
          enabled: true,
          label: "役割",
          value: this.TheSb.member_status_label(this.member_info),
        },
        {
          enabled: true,
          label: "手番",
          value: this.TheSb.user_name_to_display_turns(this.member_info.from_user_name) ?? "なし",
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
          value: `${this.member_info.ac_events_hash.received || 0}回 リジェクト${this.member_info.ac_events_hash.rejected || 0}回`,
        },
        {
          enabled: true,
          label: "API Version",
          value: this.member_info.API_VERSION,
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
          value: this.member_info.from_session_id,
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
@import "../support.sass"
.MemberInfoModal
  +modal_width(480px)
  th:not([align])
    white-space: nowrap
    text-align: right
    width: 1%
</style>
