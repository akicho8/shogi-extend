<template lang="pug">
.AppearanceUi.box
  .title.is-6 スタイル設定
  SimpleRadioButton(:base="TheSb" model_name="AppearanceThemeInfo" var_name="appearance_theme_key" custom-class="is-small" element_size="is-small")
  SimpleSlider.is-hidden-touch(:base="TheSb" label="盤の大きさ" var_name="board_width" :min="60" :max="100" :step="1.0")
</template>

<script>
export default {
  name: "AppearanceUi",
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"
.AppearanceUi
  __css_keep__: 0
</style>
