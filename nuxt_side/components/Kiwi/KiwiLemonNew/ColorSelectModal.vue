<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 配色選択
    .delete(@click="close_handle")
  .modal-card-body
    .columns.is-multiline.is-variable.is-0-mobile.is-3-tablet.is-3-desktop.is-3-widescreen.is-3-fullhd
      template(v-for="e in base.ColorThemeInfo.values")
        template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
          template(v-if="!e.separator")
            .column(:class="base.column_size_info.column_class" v-if="base.column_size_code !== null")
              .card.is-clickable(@click="click_handle(e)")
                .card-image
                  figure.image
                    img(:src="e.thumbnail_url(base)" loading="lazy")
                .card-content.px-2.py-2.is-size-7
                  template(v-if="e.key === base.color_theme_key")
                    b-tag(type="is-primary" size="is-small") {{e.name}}
                  template(v-else)
                    | {{e.name}}
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
    .slider_container.is-hidden-mobile
      b-slider(:min="0" :max="base.ColumnSizeInfo.values.length - 1" :tooltip="false" rounded v-model="base.column_size_code" type="is-primary" @input="slider_change_handle")
        template(v-for="e in base.ColumnSizeInfo.values")
          b-slider-tick(:value="e.code")
</template>

<script>
import { support_child   } from "./support_child.js"

export default {
  name: "ColorSelectModal",
  mixins: [
    support_child,
  ],
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
    click_handle(e) {
      if (this.base.color_theme_key === e.key) {
      } else {
      }
      this.sfx_click()
      this.base.color_theme_key = e.key
      this.talk(this.base.color_theme_info.introduction)
      this.$emit("close")
    },
    slider_change_handle(code) {
      if (this.mounted_next_p) {
        this.sfx_click()
      }
    },
  },
}
</script>

<style lang="sass">
@import "all_support.sass"
.ColorSelectModal
  +modal_width_auto
  .modal-card-body
    padding: 1.5rem
    white-space: pre-wrap
    word-break: break-all
  .slider_container
    width: 6rem
</style>
