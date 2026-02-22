<template lang="pug">
.SbStartStep.box
  .title.is-6.mb-0 対局するには？
  .buttons
    template(v-for="e in SB.start_steps")
      //- https://buefy.org/documentation/button
      b-button.is_active_unset(
        :key="e.key"
        :class="[e.func, {todo_p: SB[e.todo_p], done_p: SB[e.done_p]}]"
        :focused="SB[e.todo_p]"
        expanded
        @click="() => SB[e.key]()"
        )
        XemojiWrap(:str="e.icon")
        .button_label {{e.name}}
        template(v-if="SB[e.done_p]")
          XemojiWrap.right_mark(str="✅")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbStartStep",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbStartStep
  .title
    margin-bottom: 0

  .button > span                   // ボタンの中身
    flex-grow: 1                   // まず flex の子要素として横幅最大化する(重要)

    display: flex                  // さらにそのなかで flex にする
    align-items: center            // Y軸を中心にする
    gap: 0.75rem                   // 絵文字と文章の隙間

  // .button_content
  //   display: flex
  //   align-items: center
  //   justify-content: space-between
  //   flex-grow: 1                   // 横幅を最大化する
  //   gap: 0.75rem                   // 絵文字と文章の隙間
  //   // width: 100%

  // .button_label
  //   margin-right: auto

  .right_mark
    margin-left: auto           // 左の余白を吸いとって右端に配置する

  .xemoji
    // margin: 0
    // font-size: 4rem
    // height: 1rem
    // width: unset
    // height: 1em
    // margin: 0 1rem
    // line-height: 1.0
    // width: auto
    // vertical-align: inherit
    height: 4rem
    width: auto
    display: inline-block  /* ブロック要素、または inline-block にすることで高さを認識させる */
    vertical-align: middle /* 位置を中央に寄せることで、親要素の高さ計算を安定させる */

  // .right_mark
  //   margin-left: auto

  .buttons
    margin-top: 0.75rem        // "対局手順" との隙間
    margin-bottom: 0
    gap: 0.75rem               // ボタン同士の縦の隙間

  .button
    font-weight: bold
    margin-bottom: 0
    font-size: $size-3
    padding: 0.5rem 0.75rem   // ボタン内の隙間
    height: auto              // 高さは中身によって変動させる (超重要)

    // // .button 内のアイコンは位置を微調整されているためリセットする
    // .icon
    //   margin-right: 0
    //   margin-left: 0
    //   line-height: 1.0

    // button 中身は span で囲まれている
    // > span
    //   //   display: flex
    //   //   align-items: center
    //   justify-content: flex-start
    //   //   justify-content: space-between
    //   //   flex-grow: 1          // 横幅最大化
    // justify-content: flex-start // ボタンの中身は

    // > span
    //   //   display: flex
    //   //   align-items: center
    //   // justify-content: flex-start
    //   //   justify-content: space-between
    //   // flex-grow: 1          // 横幅最大化(重要)
    //   // justify-content: flex-start // ボタンの中身は

  // .button.todo_p
  //   border: 1px solid blue

.STAGE-development-x
  .SbStartStep
    .button_content
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .button_label
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .xemoji
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .icon
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .button > span
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
