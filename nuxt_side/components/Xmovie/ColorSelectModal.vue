<template lang="pug">
//- (style="width:auto")
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 配色選択

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    .columns.is-multiline.is-variable.is-0-mobile.is-1-tablet.is-2-desktop.is-3-widescreen
      template(v-for="e in base.ColorThemeInfo.values")
        template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
          template(v-if="!e.separator")
            .column.is-4-tablet.is-3-desktop.is-2-widescreen
              .card.is-clickable(@click="click_handle(e)")
                .card-image
                  figure.image
                    img(:src="e.thumbnail_url(base)" loading="lazy")
                .card-content.px-2.py-2.is-size-7
                  template(v-if="e.key === base.color_theme_key")
                    b-tag(type="is-primary" size="is-small") {{e.name}}
                  template(v-else)
                    | {{e.name}}

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    //- b-button.send_button(@click="submit_handle" type="is-primary") 適用
</template>

<script>
import { support_child   } from "./support_child.js"

export default {
  name: "ColorSelectModal",
  mixins: [
    support_child,
  ],
  props: {
    // record: { type: Object, required: true },
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    click_handle(e) {
      if (this.base.color_theme_key === e.key) {
      } else {
      }
      this.sound_play("click")
      this.base.color_theme_key = e.key
      this.$emit("close")
    },

    // test_handle() {
    //   this.sound_play("click")
    //   this.base.ml_add_test()
    // },
    submit_handle() {
      // if (this.present_p(this.base.message_body2)) {
      //   this.sound_play("click")
      //   this.base.message_share({message: this.base.message_body2})
      //   this.base.message_body2 = ""
      //   this.input_focus()
      // }
    },
    // input_focus() {
    //   this.desktop_focus_to(this.$refs.message_input_tag)
    // },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ColorSelectModal
  .modal-card, .modal-card-content
    +tablet
      width: 100%
  .modal-card-body
    padding: 1.5rem
    // .field:not(:first-child)
    //   margin-top: 1.25rem
    white-space: pre-wrap
    word-break: break-all

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
