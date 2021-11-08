<template lang="pug">
b-dropdown.ShareBoardColorThemeDropdown(v-model="base.color_theme_key" @active-change="e => e && sound_play_click()" position="is-bottom-left" :max-height="screen_is_desktop ? '50vh' : null" :scrollable="screen_is_desktop" @change="base.color_theme_key_change_handle")
  template(#trigger)
    b-button(:label="base.color_theme_info.name" icon-right="menu-down" size="is-small")
  template(v-for="e in base.ColorThemeInfo.values")
    template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
      template(v-if="e.separator")
        b-dropdown-item(separator)
      template(v-else)
        b-dropdown-item(:class="e.key" :value="e.key" @click="base.color_theme_item_click_handle(e)")
          .media
            .media-content
              .is_line_break_on.is-size-7
                | {{e.name}}
              img.is-block(:src="e.thumbnail_url(base)" loading="lazy")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardColorThemeDropdown",
  mixins: [support_child],
  data() {
    return {
      screen_is_desktop: null,
    }
  },
  beforeMount() {
    this.screen_is_desktop = this.screen_match_p("desktop")
  },
}
</script>

<style lang="sass">
.ShareBoardColorThemeDropdown
  // 上下の不自然な隙間を取る
  .dropdown-content
    padding-top: 0
    padding-bottom: 0
    .dropdown-item
      padding: 0.75rem
      +desktop
        min-width: 8rem
</style>
