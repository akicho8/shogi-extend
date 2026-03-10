<template lang="pug">
.SbStartStep.box
  .title.is-6.mb-0 対局するには？
  .buttons
    template(v-for="e in SB.start_steps")
      //- https://buefy.org/documentation/button
      b-button.is_active_unset(
        :key="e.key"
        :class="[e.key, {todo_p: SB[e.todo_p], done_p: SB[e.done_p]}]"
        :focused="SB[e.todo_p]"
        expanded
        @click="() => SB[e.key]()"
        )
        template(v-if="!SB[e.done_p]")
          i.mdi(:class="e.icon")
        template(v-if="SB[e.done_p]")
          i.mdi.mdi-checkbox-marked-circle
        template(v-if="true")
          .button_label {{e.name}}
        template(v-if="false")
          .button_label.is-hidden-mobile {{e.name}}
          .button_label.is-hidden-tablet {{e.mobile_name ?? e.name}}
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

  .buttons
    margin-top: 0.75rem     // "対局するには？" との隙間
    margin-bottom: 0
    gap: 0.5rem             // ボタン同士の縦の隙間

  .button
    margin-bottom: 0
    font-size: $size-3      // かなりでかくする
    padding: 0.5rem 1.0rem  // ボタン内の隙間
    height: auto            // 高さは中身によって変動させる (超重要)
    &.todo_p
      font-weight: bold
    &.done_p
      font-weight: normal
      i
        color: $success

  .button > span            // ボタンの中身
    flex-grow: 1            // まず flex の子要素として横幅最大化する(重要)
    /* -- */
    display: flex           // さらにそのなかで flex にする
    align-items: center     // Y軸を中心にする
    gap: 0.75rem            // 左の絵文字とラベルの隙間
    line-height: 1.0        // ボタン内の上下のパディングの二重調整を避けるためこちらは0にしておく

  i
    color: $danger          // 番号
    font-size: 0.8em        // 番号は少し小さくする

  .right_icon
    margin-left: auto       // 左の余白を吸いとって右端に配置する

.STAGE-development-x
  .SbStartStep
    .button_content
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .button_label
      border: 1px dashed change_color($primary, $alpha: 0.5)
    i
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .button > span
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
