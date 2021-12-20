<template lang="pug">
.KiwiLemonNewFormText
  ////////////////////////////////////////////////////////////////////////////////
  .field_block.body_field

    b-field.mb-0.mt-2(:type="base.body_field_type")
      template(#label)
        .label_text 棋譜
        b-button.mb-0.ml-1.any_source_trim_handle(@click="base.any_source_trim_handle" size="is-small") トリム
        b-button.mb-0.ml-1.any_source_edit_handle(@click="base.any_source_edit_handle" size="is-small") 編集
      b-input(type="textarea" ref="body" v-model.trim="base.body" expanded rows="4" placeholder="KIF KI2 CSA SFEN BOD の本体かURL。共有将棋盤・ぴよ将棋・KENTO・将棋DB2・将棋ウォーズのURL。棋譜自体を引数に含むURL。棋譜URLをコンテンツに含むサイトURL。戦法名・囲い名などを入力してください")

    p.mt-0(v-if="false")
      b-button(@click="base.any_source_edit_handle" type="is-white" size="is-small" icon-left="open-in-new")
        | 共有将棋盤で確認
      a.is-size-7(@click="base.any_source_edit_handle")
        b-icon(icon="open-in-new" size="is-small")
        | 共有将棋盤で確認

  b-field.field_block(label="表紙")
    template(#message)
      | 全角で最大<b>横24文字×10行</b>。空なら表紙は省く。センタリング表示する。自動的には折り返さないので適宜改行を入れるべし。決して絵文字や色のある文字は入力してはならぬ。
    b-input(type="textarea" v-model.trim="base.cover_text" expanded rows="4" placeholder="御城将棋\n☗六代大橋宗銀 vs ☖伊藤印達\n1711-02-28")

  ////////////////////////////////////////////////////////////////////////////////

</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewFormText",
  mixins: [support_child],
  mounted() {
    this.base.body_focus()
  },
}
</script>

<style lang="sass">
.KiwiLemonNewFormText
  .body_field
    label
      display: flex
      align-items: center
      justify-content: flex-start
      .label_text
        margin-right: auto      // 自分より右側のやつらを右端に飛ばす
</style>
