<template lang="pug">
.FormalSheetShow.has_formal_sheet
  .section
    // 斜線の定義
    svg(display="none")
      defs
        symbol#svg_slash(preserveAspectRatio="none")
          line(x1="0" y1="100%" x2="100%" y2="0" stroke="black" stroke-width="0.5")

    .fixed_printer_button_container.is_screen_only
      button.button.is-primary.is-large(@click="printer_handle")
        b-icon(icon="printer" size="is-medium")

    .fixed_font_switch_container.is_screen_only
      b-field(label="フォント" custom-class="is-small")
        b-radio-button(v-model="font_key" native-value="mincho" size="is-small") 明朝
        b-radio-button(v-model="font_key" native-value="gothic" size="is-small") ゴシック
      b-field.mt-4(label="文字サイズ(mm)" custom-class="is-small")
        b-numberinput(size="is-small" controls-position="compact" v-model="font_size" :min="0" :max="10" :step="0.01" exponential)

    .formal_sheet_workspace(
      :class="{is_mincho: font_key === 'mincho'}"
      :contenteditable="direct_editable_p ? 'true' : 'false'"
      )
      template(v-for="(_, page_index) in new_info.page_count")
        .sheet(:style="{'font-size': `${font_size}mm`}")
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
const AUTO_PRINT = false

import { isMobile } from "@/components/models/isMobile.js"

export default {
  name: "FormalSheetShow",
  props: {
    info: { type: Object, required: true },
  },
  data() {
    return {
      new_info: this.info,
      font_key: "mincho",
      font_size: 3.9,
    }
  },
  head() {
    return {
      title: this.info.html_title,
      titleTemplate: null,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.info.html_title                              },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/formal-sheet.png" },
        { hid: "og:description", property: "og:description", content: ""                                                },
      ],
    }
  },
  watch: {
    font_key() {
      this.sound_play("click")
    },
    font_size() {
      this.sound_play("click")
    },
  },
  methods: {
    printer_handle() {
      window.print()
    },

    edit_to(page_index, key) {
      if (isMobile.any()) {
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
    if (AUTO_PRINT) {
      setTimeout(() => {
        window.print()
        window.close()
      }, 200)
    }

    this.dialog_ok(`
       <div class="content">
         <ol>
           <li class="mt-4">用紙の各項目は変更できます</li>
           <li class="mt-4">PDFにするには印刷時の送信先を<b>PDFに保存</b>にしてください</li>
           <li class="mt-4">
             ブラウザの設定でフォントの最小サイズを制限していると罫線がずれる場合があります
             <div class="mt-3">ブラウザごとの解除方法</div>
             <ul class="mt-3">
               <li class="mt-3">Google Chrome:「環境設定」→「デザイン」→「フォントをカスタマイズ」→<b>最小フォントサイズ</b>を極小にする</li>
               <li class="mt-3">Safari:「環境設定」→「詳細」→<b>これより小さいフォントサイズを使わない</b>のチェックを外す</li>
             </ul>
           </li>
         </ol>
       </div>`, {talk: false})
  },

  computed: {
    // PCのブラウザのみ有効にする
    // モバイルブラウザは反応しないので常時有効でもよいが念のためPCの場合のみにしとく
    direct_editable_p() {
      return !isMobile.any()
    },
  },
}
</script>

<style lang="sass">
@import "FormalSheetShow/_all.sass"
.FormalSheetShow
  .is_mincho
    // YuGothic  ← Mac
    // Yu Gothic ← Windows
    font-family: "YuMincho", "Yu Mincho", serif
  .b-radio
    min-width: 5rem
</style>
