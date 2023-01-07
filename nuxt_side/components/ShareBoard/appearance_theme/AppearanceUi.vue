<template lang="pug">
.AppearanceUi.box
  .title.is-6 スタイル設定
  SimpleRadioButtons(:base="TheSb" model_name="AppearanceThemeInfo" var_name="appearance_theme_key" custom-class="is-small")
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
</style>
