<template lang="pug">
.FormalSheetShow
  // 斜線の定義
  svg(display="none")
    defs
      symbol#svg_slash(preserveAspectRatio="none")
        line(x1="0" y1="100%" x2="100%" y2="0" stroke="black" stroke-width="0.5")

  .fixed_printer_button_container.is_screen_only
    button.button.is-primary.is-large(@click="printer_handle")
      b-icon(icon="printer" size="is-medium")

  .formal_sheet_workspace(:class="new_info.workspace_class")
    template(v-for="(_, page_index) in new_info.page_count")
      .sheet
        .sheet_body
          .tables_box_container
            .tables_box
              template(v-if="new_info.page_count >= 2")
                .page_no
                  | No. {{page_index + 1}} / {{new_info.page_count}}

              ////////////////////////////////////////////////////////////////////////////////
              table.is_head1
                tr
                  td.b_b.b_r.td_players(rowspan="4")
                    .value
                      | 対 局 者

                  td.b_b.b_r.td_grade(rowspan="2" @click="edit_to(page_index, 'grade_name_for_black')" :class="{editable: page_index === 0}")
                    | {{new_info.grade_name_for_black}}

                  td.b_b.td_location_label(rowspan="2")
                    .kanji
                      | {{new_info.location_kanji_char_black}}
                    .mark
                      | ☗
                  td.b_b.b_r.td_player_name(rowspan="2" @click="edit_to(page_index, 'player_name_for_black')" :class="{editable: page_index === 0}")
                    | {{new_info.player_name_for_black}}
                  td.b_b.b_r.td_tournament_label(rowspan="2")
                    .value
                      | &nbsp;棋戦名
                  td.b_b.b_r(@click="edit_to(page_index, 'tournament_name')" :class="{editable: page_index === 0}")
                    | {{new_info.tournament_name}}
                  td.b_b.b_r.td_datetime_label
                    | 開始
                  td.b_b.td_datetime(@click="edit_to(page_index, 'begin_at_s')" :class="{editable: page_index === 0}")
                    | {{new_info.begin_at_s}}
                tr
                  td.b_b.b_r(@click="edit_to(page_index, 'rule_name')" :class="{editable: page_index === 0}")
                    | {{new_info.rule_name}}
                  td.b_b.b_r.td_datetime_label
                    | 終了
                  td.b_b.td_datetime(@click="edit_to(page_index, 'end_at_s')" :class="{editable: page_index === 0}")
                    | {{new_info.end_at_s}}

                tr
                  td.b_b.b_r.td_grade(rowspan="2" @click="edit_to(page_index, 'grade_name_for_white')" :class="{editable: page_index === 0}")
                    | {{new_info.grade_name_for_white}}

                  td.b_b.td_location_label(rowspan="2")
                    .kanji
                      | {{new_info.location_kanji_char_white}}
                    .mark
                      | ☖

                  td.b_b.b_r.td_player_name(rowspan="2" @click="edit_to(page_index, 'player_name_for_white')" :class="{editable: page_index === 0}")
                    | {{new_info.player_name_for_white}}

                  td.b_b.b_r.td_playing_field_label(rowspan="2")
                    .value
                      | &nbsp;対局場
                  td.b_b.b_r.td_playing_field_name(rowspan="2" @click="edit_to(page_index, 'playing_field_name')" :class="{editable: page_index === 0}")
                    | {{new_info.playing_field_name}}

                  td.b_b.b_r
                    | 昼休
                  td.b_b(@click="edit_to(page_index, 'hirukyuu')" :class="{editable: page_index === 0}")
                    template(v-if="page_index === 0")
                      | {{new_info.hirukyuu}}

                tr
                  td.b_b.b_r
                    | 夕休
                  td.b_b(@click="edit_to(page_index, 'yuukyuu')" :class="{editable: page_index === 0}")
                    template(v-if="page_index === 0")
                      | {{new_info.yuukyuu}}
              ////////////////////////////////////////////////////////////////////////////////

              table.is_head2
                tr
                  td.b_b.b_r.td_preset
                    .value
                      | 手 合 割
                  td.b_b.b_r.td_preset_body(@click="edit_to(page_index, 'preset_str')" :class="{editable: page_index === 0}")
                    template(v-if="page_index === 0")
                      | {{new_info.preset_str}}

                  td.b_b.td_desc_label(rowspan="4")
                    .value
                      | 備考

                  td.b_b.b_r.td_desc_body(rowspan="4" @click="edit_to(page_index, 'desc_body')" :class="{editable: page_index === 0}")
                    template(v-if="page_index === 0")
                      // 値がないときに .value のタグを取らないとCSSの :empty にマッチしないため v-if を入れている
                      .value(v-if="new_info.desc_body" v-html="new_info.desc_body")

                  td.b_b.b_r
                    | 手数
                  td.b_b(@click="edit_to(page_index, 'battle_result_str')" :class="{editable: page_index === 0}")
                    template(v-if="page_index === 0")
                      | {{new_info.battle_result_str}}
                tr
                  td.b_b.b_r.basic_label
                    | 持 時 間
                  td.b_b.b_r(@click="edit_to(page_index, 'hold_time_str')" :class="{editable: page_index === 0}")
                    template(v-if="page_index === 0")
                      | {{new_info.hold_time_str}}

                  td.double_border.basic_label(rowspan="2")
                    | 戦型
                  td.double_border.td_strategy_pack_body(rowspan="2" @click="edit_to(page_index, 'strategy_pack_for_all')" :class="{editable: page_index === 0}")
                    template(v-if="page_index === 0")
                      // 値がないときに .value のタグを取らないとCSSの :empty にマッチしないため v-if を入れている
                      .value(v-html="new_info.strategy_pack_for_all" v-if="new_info.strategy_pack_for_all")

                tr
                  td.b_b.b_r.basic_label(rowspan="2")
                    | 消費時間
                  td.b_b.b_r.td_total_seconds(@click="edit_to(page_index, 'total_seconds_str_for_black')" :class="{editable: page_index === 0}")
                    template(v-if="page_index === 0")
                      | {{new_info.total_seconds_str_for_black}}
                tr
                  td.b_b.b_r.td_total_seconds(@click="edit_to(page_index, 'total_seconds_str_for_white')" :class="{editable: page_index === 0}")
                    template(v-if="page_index === 0")
                      | {{new_info.total_seconds_str_for_white}}

                  td.b_b.b_r.basic_label
                    | 記録係
                  td.b_b(@click="edit_to(page_index, 'umpire_name')" :class="{editable: page_index === 0}")
                    | {{new_info.umpire_name}}

              table.is_body
                thead
                  tr
                    template(v-for="(_, x) in new_info.outer_columns")
                      template(v-for="(_, left_or_right) in new_info.inner_fixed_columns")
                        td
                          template(v-if="(left_or_right % 2) === 0") ☗
                          template(v-else) ☖
                        td.td_spend_times
                          svg
                            use(xlink:href="#svg_slash")
                          .values
                            .used_seconds 消費
                            .total_seconds 通計
                tbody
                  template(v-for="(yd, yi) in new_info.cell_matrix[page_index]")
                    tr.kifu_body_row
                      template(v-for="(xd, xi) in yd")
                        template(v-for="(e, left_or_right) in xd")
                          td.td_kifu_data(:class="e.class") {{e.value}}
                          td.td_spend_times
                            svg
                              use(xlink:href="#svg_slash")
                            .values
                              .used_seconds {{e.used_seconds}}
                              .total_seconds {{e.total_seconds}}
</template>

<script>

export default {
  name: "FormalSheetShow",
  props: {
    info: { type: Object, required: true },
  },
  data() {
    return {
      new_info: this.info,
    }
  },
  head() {
    return {
      title: this.info.html_title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.info.html_title },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                                },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-formal-sheets-key.png" },
        { hid: "og:description", property: "og:description", content: ""},
      ],
    }
  },
  methods: {
    printer_handle() {
      window.print()
    },

    edit_to(page_index, key) {
      if (page_index === 0) {
        this.$buefy.dialog.prompt({
          title: "編集",
          inputAttrs: {type: "text", value: this.new_info[key], required: false},
          confirmText: "更新",
          cancelText: "キャンセル",
          onConfirm: (value) => {
            if (this.new_info[key] !== value) {
              this.$set(this.new_info, key, value)
              this.$buefy.toast.open({message: `更新しました`, position: "is-bottom"})
            }
          },
        })
      }
    },
  },

  mounted() {
    // 自動的に印刷する場合
    setTimeout(() => {
      // window.print()
      // window.close()
    }, 200)
  },
}
</script>

<style lang="sass">
@import "@/components/sass/formal_sheet/_all.sass"
.FormalSheetShow
</style>
