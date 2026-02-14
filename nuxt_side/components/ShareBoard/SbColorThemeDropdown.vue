<template lang="pug">
b-dropdown.SbColorThemeDropdown(v-model="SB.color_theme_key" @active-change="e => e && sfx_click()" position="is-bottom-left" :max-height="screen_is_desktop ? '50dvh' : null" :scrollable="screen_is_desktop" @change="SB.color_theme_key_change_handle")
  template(#trigger)
    b-button(:label="SB.color_theme_info.name" icon-right="menu-down" size="is-small")
  template(v-for="e in SB.ColorThemeInfo.values")
    template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
      template(v-if="e.separator")
        b-dropdown-item(separator)
      template(v-else)
        b-dropdown-item(:class="e.key" :value="e.key" @click="SB.color_theme_item_click_handle(e)")
          .media
            .media-content
              .is_line_break_on.is-size-7
                | {{e.name}}
              img.is-block(:src="e.thumbnail_url(SB)" loading="lazy")
</template>

<script>
import { support_child } from "./support_child.js"
import { ScreenSizeDetector } from "@/components/models/screen_size_detector.js"

export default {
  name: "SbColorThemeDropdown",
  mixins: [support_child],
  data() {
    return {
      screen_is_desktop: null,
    }
  },
  beforeMount() {
    this.screen_is_desktop = ScreenSizeDetector.match_p("desktop")
  },
}
</script>

<style lang="sass">
.SbColorThemeDropdown
  // 上下の不自然な隙間を取る
  .dropdown-content
    padding-top: 0
    padding-bottom: 0
    .dropdown-item
      padding: 0.75rem
      +desktop
        min-width: 8rem
</style>
