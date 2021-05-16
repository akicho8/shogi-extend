<template lang="pug">
.modal-card.GeneralHelpModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 使い方

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    b-tabs(v-model="tab_index")
      b-tab-item(label="FAQ")
        .faq_block
          .faq_q 盤が同期してなくない？
          .faq_a
            .content
              p
                | 盤の同期は次の操作をしたときだけです
              ul
                li 新しい手を指した
                li 「初期配置に戻す」を実行
                li 「1手戻す」を実行
                li 「局面を全員に転送」を実行
              p
                | 盤の下のコントローラーで動かしたときの変化は自分の盤だけです

        .faq_block
          .faq_q ハンドルネームを変更するには？
          .faq_a
            p
              | メニューの「部屋に入る」から「退室」

        .faq_block(v-if="development_p")
          .faq_q タイトル
          .faq_a
            p
              | 親譲りの無鉄砲で小供の時から損ばかりしている。小学校に居る時分学校の二階から飛び降りて一週間ほど腰を抜かした事がある。なぜそんな無闇をしたと聞く人があるかも知れぬ。別段深い理由でもない。新築の二階から首を出していたら、同級生の一人が冗談に、いくら威張っても、そこから飛び降りる事は出来まい。弱虫やーい。と囃したからである。小使に負ぶさって帰って来た時、おやじが大きな眼をして二階ぐらいから飛び降りて腰を抜かす奴があるかと云ったから、この次は抜かさずに飛んで見せますと答えた。

      b-tab-item(label="仕様" v-if="false")
        .faq_block
          .faq_q タイトル
          .faq_a
            p
              | 親譲りの無鉄砲で小供の時から損ばかりしている。小学校に居る時分学校の二階から飛び降りて一週間ほど腰を抜かした事がある。なぜそんな無闇をしたと聞く人があるかも知れぬ。別段深い理由でもない。新築の二階から首を出していたら、同級生の一人が冗談に、いくら威張っても、そこから飛び降りる事は出来まい。弱虫やーい。と囃したからである。小使に負ぶさって帰って来た時、おやじが大きな眼をして二階ぐらいから飛び降りて腰を抜かす奴があるかと云ったから、この次は抜かさずに飛んで見せますと答えた。

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "GeneralHelpModal",
  mixins: [
    support_child,
  ],
  data() {
    return {
      tab_index: 0,
    }
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.GeneralHelpModal
  height: 80vh

  // +tablet
  //   width: 64rem
  .modal-card-body
    padding: 0

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold

  .b-tabs
    .tab-content
      padding: 1.5rem

  .faq_block
    &:not(:first-child)
      margin-top: 2rem
    .faq_q
      font-size: $size-5
      font-weight: bold
    .faq_a
      margin-top: 0.5rem

</style>
