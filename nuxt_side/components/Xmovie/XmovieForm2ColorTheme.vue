<template lang="pug">
.XmovieForm2ColorTheme.one_block
  b-field(:label="base.ColorThemeInfo.field_label" :message="base.ColorThemeInfo.fetch(base.color_theme_key).message || base.ColorThemeInfo.field_message")
    .control
      b-dropdown(v-model="base.color_theme_key" @active-change="e => e && sound_play('click')")
        template(#trigger)
          b-button(:label="base.color_theme_info.name" icon-right="menu-down")
        template(v-for="e in base.ColorThemeInfo.values")
          template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
            template(v-if="e.separator")
              b-dropdown-item(separator)
            template(v-else)
              b-dropdown-item(:value="e.key" @click="sound_play('click')")
                .media
                  .media-content
                    .is_line_break_on
                      | {{e.name}}
                    img.is-block.mt-2(:src="e.thumbnail_url(base)")

  XmovieImageUpload(:base="base" label="背景" :file_info.sync="base.bg_file1")
  XmovieImageUpload(:base="base" label="盤面" :file_info.sync="base.bg_file2")
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
      padding: 1.25rem
      +desktop
        min-width: 32rem
</style>
