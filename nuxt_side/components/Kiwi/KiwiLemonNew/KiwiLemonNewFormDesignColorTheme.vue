<template lang="pug">
.KiwiLemonNewFormDesignColorTheme.field_block
  b-field(:label="base.ColorThemeInfo.field_label" :message="base.ColorThemeInfo.fetch(base.color_theme_key).message || base.ColorThemeInfo.field_message")
    .control
      b-button(@click="base.color_select_modal_handle" icon-right="view-comfy") {{base.color_theme_info.name}}

  b-field(:label="base.ColorThemeInfo.field_label" :message="base.ColorThemeInfo.fetch(base.color_theme_key).message || base.ColorThemeInfo.field_message" v-if="development_p && $gs.blank_p($route.query.__color_theme_key_dropdown_skip__)")
    .control
      b-dropdown(v-model="base.color_theme_key" @active-change="e => e && sfx_click()")
        template(#trigger)
          b-button(:label="base.color_theme_info.name" icon-right="menu-down")
        template(v-for="e in base.ColorThemeInfo.values")
          template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
            template(v-if="e.separator")
              b-dropdown-item(separator)
            template(v-else)
              b-dropdown-item(:value="e.key" @click="sfx_click()")
                .media
                  .media-content
                    .is_line_break_on
                      | {{e.name}}
                    img.is-block.mt-2(:src="e.thumbnail_url(base)" loading="lazy")

  KiwiLemonNewImageUpload(:base="base" label="背景"           :file_info.sync="base.u_bg_file")
  KiwiLemonNewImageUpload(:base="base" label="盤面テクスチャ" :file_info.sync="base.u_fg_file")
  KiwiLemonNewImageUpload(:base="base" label="駒テクスチャ"   :file_info.sync="base.u_pt_file")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewFormDesignColorTheme",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiLemonNewFormDesignColorTheme
  // 上下の不自然な隙間を取る
  .dropdown-content
    padding-top: 0
    padding-bottom: 0
    .dropdown-item
      padding: 1.25rem
      +desktop
        min-width: 32rem
</style>
