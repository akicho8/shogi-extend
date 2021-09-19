<template lang="pug">
.XmovieFormSource
  ////////////////////////////////////////////////////////////////////////////////
  .one_block.body_field
    .buttons.mb-0.has-addons
      b-button.mb-0(@click="base.any_source_trim_handle" icon-left="content-cut" size="is-small") トリム

    b-field.mb-0.mt-1(:type="base.body_field_type")
      template(#label v-if="false")
        .label_text.is-invisible 棋譜
        a.is-size-7(@click="base.share_board_handle" v-if="development_p")
          b-icon(icon="open-in-new" size="is-small")
          | 将棋盤
        a.is-size-7(@click="base.adapter_handle" v-if="development_p")
          b-icon(icon="open-in-new" size="is-small")
          | 棋譜変換
      b-input(type="textarea" ref="body" v-model.trim="base.body" expanded rows="4" placeholder="KIF KI2 CSA SFEN BOD の中身またはURL。KENTOや将棋DB2のSFEN風パラメータを含むURL。棋譜ファイルへのURLをコンテンツに含むサイトのURL。戦法名・囲い名などを入力してください")

    p.mt-0(v-if="false")
      b-button(@click="base.share_board_handle" type="is-white" size="is-small" icon-left="open-in-new")
        | 共有将棋盤で確認
      a.is-size-7(@click="base.share_board_handle")
        b-icon(icon="open-in-new" size="is-small")
        | 共有将棋盤で確認

  ////////////////////////////////////////////////////////////////////////////////

</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieFormSource",
  mixins: [support_child],
  mounted() {
    this.base.body_focus()
  },
}
</script>

<style lang="sass">
.XmovieFormSource
  // .field:not(:first-child)
  //   margin-top: 1.5rem
  .body_field
    label
      display: flex
      align-items: center
      justify-content: flex-start
      .label_text
        margin-right: auto // aリンクたちを右に押す
      a:not(:first-child)
        margin-left: 0.25rem // aリンク同士の間を開ける
        font-weight: normal  // label のなかは bold になるため元に戻す
    textarea
      +mobile
        height: 9rem
      +tablet
        height: 16rem
</style>
