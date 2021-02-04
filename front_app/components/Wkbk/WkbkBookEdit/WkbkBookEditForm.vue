<template lang="pug">
.WkbkBookEditForm
  .columns.is-gapless
    .column
      // @click.native="sound_play('click')" すると2連続で呼ばれてしまうので指定してない
      // @click.native="toast_ok(1)" すると2回呼ばれていることがわかる
      b-upload(@input="base.upload_handle" @click.native="debug_alert('2回呼ばれる不具合があるため効果音OFF')")
        figure.image.is-clickable
          img(:src="base.image_source")
          .position_center
            b-icon.has-text-white(icon="camera" size="is-large")
          .position_top_right
            .size_info.is-size-7
              | 1200x630 推奨

      b-field(label="タイトル" label-position="on-border")
        b-input(v-model.trim="base.book.title" required)

      b-field(label="概要" label-position="on-border")
        b-input(v-model.trim="base.book.description" type="textarea" rows="5")

      b-field(label="出題順序" label-position="on-border")
        b-select(v-model="base.book.sequence_key" required)
          option(v-for="e in base.SequenceInfo.values" :value="e.key" v-text="e.name")

      b-field(label="表示範囲" custom-class="is-small")
        b-field.is-marginless
          template(v-for="e in base.FolderInfo.values")
            b-radio-button(v-model="base.book.folder_key" :native-value="e.key") {{e.name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookEditForm",
  mixins: [
    support_child,
  ],
  watch: {
    "book.sequence_key": {
      handler(v) {
        const sequence_info = this.base.SequenceInfo.fetch(v)
        this.sound_play("click")
        this.talk(sequence_info.name)
      },
    },
    "book.folder_key": {
      handler(v) {
        const folder_info = this.base.FolderInfo.fetch(v)
        this.sound_play("click")
        this.talk(folder_info.name)
      },
    },
  },
  computed: {
    book() { return this.base.book },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookEditForm
  +mobile
    --gap: calc(#{$wkbk_share_gap} * 0.75)
  +tablet
    --gap: #{$wkbk_share_gap}

  margin: var(--gap)

  .field:not(:first-child)
    margin-top: var(--gap)

  .help
    color: $grey
    font-size: $size-7

  // iPhoneでselectをタップするとズームするのはフォントサイズが16px未満だから
  +touch
    input, textarea, select
      font-size: 16px

  .image
    img
      +desktop
        width: unset
        height: calc(630px * 0.5)

    // 中央のカメラ
    .position_center
      position: absolute
      top: 0
      width: 100%
      height: 100%

      display: flex
      align-items: center
      justify-content: center
      flex-direction: column

      .icon
        filter: drop-shadow(0px 0px 12px rgba(0, 0, 0, 1.0))

    // 1200x630 推奨
    .position_top_right
      position: absolute
      top: 0
      right: 0
      .size_info
        margin: 6px
        padding: 0.25rem 0.6rem
        color: $white
        background-color: change_color($black, $alpha: 0.6)
        font-weight: bold
        border-radius: 3px
</style>
