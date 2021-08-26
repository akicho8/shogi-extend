<template lang="pug">
b-field.one_block.XmovieForm2ColorTheme(:label="base.ColorThemeInfo.field_label" :message="base.ColorThemeInfo.fetch(base.color_theme_key).message || base.ColorThemeInfo.field_message")
  .control
    b-dropdown(v-model="base.color_theme_key" @active-change="e => e && sound_play('click')")
      template(#trigger)
        b-button(:label="base.color_theme_info.name" icon-right="menu-down")
      template(v-for="e in base.ColorThemeInfo.values")
        template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
          b-dropdown-item(:value="e.key" @click="sound_play('click')")
            .media
              .media-left(v-html="e.name")
                //- | {{e.name}}
                //- | {{e.real_ext}}
              .media-content
                //- .has-text-weight-bold {{e.name}}
                //- h3 {{e.name}}
                //- span {{e.message}}
                //- | {{e.thumbnail_url(base)}}
                //- b-img(:src="e.thumbnail_url(base)")
                img.is-block(:src="e.thumbnail_url(base)")
                //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                //- small {{e.message}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieForm2ColorTheme",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XmovieForm2ColorTheme
  // 上下の不自然な隙間を取る
  .dropdown-content
    padding-top: 0
    padding-bottom: 0


  .dropdown-item
    padding: 1.0rem
    +desktop
      min-width: 20rem
    .media
      align-items: center
      .media-left
        flex-basis: 70%
</style>
