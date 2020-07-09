<template lang="pug">
.the_pulldown_menu
  b-dropdown.dropdown_menu(position="is-bottom-left" v-if="$parent.run_mode === 'play_mode'")
    b-icon.has-text-grey-light.is_clickable(slot="trigger" icon="dots-vertical")
    template(v-if="$parent.run_mode === 'play_mode'")
      b-dropdown-item(@click="$parent.reset_handle") 盤面リセット
      b-dropdown-item(separator)
      b-dropdown-item(:href="$parent.piyo_shogi_app_with_params_url" :target="target_default") ぴよ将棋
      b-dropdown-item(:href="$parent.kento_app_with_params_url" :target="target_default") KENTO
      b-dropdown-item(@click="$parent.kifu_copy_handle") 棋譜コピー
      b-dropdown-item(:href="$parent.snapshot_image_url") 局面画像の取得
      b-dropdown-item(separator)
      b-dropdown-item(@click="$parent.title_edit") タイトル編集
    b-dropdown-item(@click="$parent.mode_toggle_handle")
      template(v-if="$parent.run_mode === 'play_mode'")
        | 局面編集
      template(v-else)
        | 局面編集(終了)
    b-dropdown-item(@click="$parent.any_source_read_handle") 棋譜の読み込み
    b-dropdown-item(@click="$parent.image_view_point_setting_handle") Twitter画像の視点
    template(v-if="$parent.run_mode === 'play_mode'")
      b-dropdown-item(@click="$parent.room_code_edit")
        | リアルタイム共有
        .has-text-danger(v-if="$parent.room_code")
          | {{$parent.room_code}}
</template>

<script>
export default {
  name: "the_pulldown_menu",
  data() {
    return {
    }
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_pulldown_menu
</style>
