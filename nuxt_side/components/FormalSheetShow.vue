<template lang="pug">
.FormalSheetShow.has_formal_sheet
  // 斜線の定義
  svg(display="none")
    defs
      symbol#svg_slash(preserveAspectRatio="none")
        line(x1="0" y1="100%" x2="100%" y2="0" stroke="black" stroke-width="0.5")

  .position_fixed.is_top_left.is_screen_only
    b-icon.back_handle.is-clickable(icon="chevron-left" size="is-medium" @click.native="back_handle")

  .position_fixed.is_top_right.is_screen_only
    b-button.printer_handle(icon-left="printer" size="is-medium" type="is-primary" @click="printer_handle")

  .position_fixed.is_bottom_left.is_screen_only
    b-field.mt-6.font_field(label="フォント" custom-class="is-small")
      b-radio-button.is_font_key_mincho(v-model="font_key" native-value="mincho" size="is-small") 明朝
      b-radio-button.is_font_key_gothic(v-model="font_key" native-value="gothic" size="is-small") ゴシック
    b-field.mt-4(label="文字サイズ(%)" custom-class="is-small")
      b-numberinput(size="is-small" controls-position="compact" v-model="font_size" :min="0" :max="200" :step="1" exponential @click.native="sfx_play_click()")
  .position_fixed.is_bottom_right.is_screen_only
    a.usage_dialog_show_handle(@click="usage_dialog_show_handle")
      b-icon(icon="information-outline" size="is-medium" type="is-primary")

  .section

    .formal_sheet_workspace(:class="{is_mincho: font_key === 'mincho'}")
      template(v-for="(_, page_index) in new_info.page_count")
        .sheet(:style="{'font-size': `${font_size}%`}")
          .sheet_body(:contenteditable="direct_editable_p ? 'true' : 'false'")
            .tables_box_container
              .tables_box
                template(v-if="new_info.page_count >= 2")
                  .page_no
                    | No. {{page_index + 1}} / {{new_info.page_count}}

                ////////////////////////////////////////////////////////////////////////////////
                table.is-unselectable.is_head1
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
                        //- なぜか上に寄ってしまうためしかたなく&nbsp;で調整している
                        | &nbsp;&nbsp;棋戦名
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
                        //- なぜか上に寄ってしまうためしかたなく&nbsp;で調整している
                        | &nbsp;&nbsp;対局場
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

                table.is-unselectable.is_head2
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

                    // 下の2つの b_b を double_border に変更すると記録係りの上の線が === になる
                    // しかし二年たって見ると不具合のように見えてしまったため b_b の --- に変更した
                    // 元から変な部分に無理に合わせる必要はない
                    td.b_b.basic_label(rowspan="2")
                      | 戦法
                    td.b_b.td_strategy_pack_body(rowspan="2" @click="edit_to(page_index, 'strategy_pack_for_all')" :class="{editable: page_index === 0}")
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

                table.is-unselectable.is_body
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
const AUTO_PRINT = false

import { MyMobile } from "@/components/models/my_mobile.js"

export default {
  name: "FormalSheetShow",
  props: {
    info: { type: Object, required: true },
  },
  data() {
    return {
      new_info: this.info,
      font_key: "mincho",
      font_size: 100,
    }
  },
  watch: {
    font_key() {
      this.sfx_play_click()
    },
  },
  methods: {
    back_handle() {
      this.sfx_play_click()
      this.back_to()
    },

    usage_dialog_show_handle() {
      this.sfx_play_click()

      this.dialog_alert({
        title: "使い方や注意点",
        message: `
        <div class="content">
          <ol class="mt-0">
            <li>
              各項目は編集できます<br>
              足りない情報があれば書き加えてください
            </li>
            <li class="mt-4">
              印刷時の送信先を<b>PDFに保存</b>に設定してください<br>
              紙に印刷するのではなく、いったんPDF化をおすすめします
            </li>
          </ol>
        </div>`
      })
    },

    printer_handle() {
      this.sfx_play_click()

      if (true) {
        let body = []
        body.push(this.new_info.tournament_name)
        body.push(this.new_info.player_name_for_black)
        body.push("vs")
        body.push(this.new_info.player_name_for_white)
        body = body.join(" ")
        this.app_log({emoji: ":プリンタ:", subject: "棋譜用紙印刷実行", body: body})
      }

      window.print()
    },

    edit_to(page_index, key) {
      if (MyMobile.mobile_p) {
        if (page_index === 0) {
          this.$buefy.dialog.prompt({
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
      }
    },
  },

  mounted() {
    this.app_log("棋譜用紙")

    if (AUTO_PRINT) {
      setTimeout(() => {
        window.print()
        window.close()
      }, 200)
    }
  },

  computed: {
    meta() {
      return {
        title: this.info.html_title,
        page_title_only: true,
        og_title: this.info.html_title,
        og_image_key: "formal-sheet",
        og_description: "",
      }
    },

    // PCのブラウザのみ有効にする
    // モバイルブラウザは反応しないので常時有効でもよいが念のためPCの場合のみにしとく
    direct_editable_p() {
      return !MyMobile.mobile_p
    },
  },
}
</script>

<style lang="sass">
@import "FormalSheetShow/_all.sass"

// https://fonts.google.com/specimen/Noto+Serif+JP?subset=japanese
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+JP:wght@400&display=swap')

.FormalSheetShow
  .is_mincho
    // YuGothic  ← Mac
    // Yu Gothic ← Windows
    //
    // もともと次のようにしていたが Android では serif に対応する明朝体フォントを持ってない
    // font-family: "YuMincho", "Yu Mincho", serif
    //
    // そのため Google Fonts を利用
    font-family: 'Noto Serif JP', serif
    // font-weight: 400            // 400 = normal
  .b-radio
    min-width: 5rem

  .back_handle
    position: fixed
    top: 32px
    left: 32px
    &:hover
      color: $primary
</style>
