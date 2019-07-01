<template lang="pug">
  b-dropdown(:hoverable="false" @click.native.stop="" :position="in_modal ? 'is-top-left' : 'is-bottom-left'")
    button.button.is-small(slot="trigger")
      //- span もっと見る
      b-icon(:icon="in_modal ? 'menu-up' : 'menu-down'")

    template(v-if="record.show_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="record.show_path")
          b-icon(icon="play" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | 詳細

    template(v-if="record.edit_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="record.edit_path")
          b-icon(icon="pencil" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | 編集

    template(v-if="record.new_and_copy_url")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="record.new_and_copy_url")
          b-icon(icon="open-in-new" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | コピペ新規

    template(v-if="record.formal_paper_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="record.formal_paper_path" target="_blank")
          b-icon(icon="note-outline" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | 棋譜印刷(PDF)

    template(v-if="record.memberships")
      b-dropdown-item(:separator="true")
      template(v-for="e in record.memberships")
        b-dropdown-item(:has-link="true" :paddingless="true")
          a(:href="e.player_info_path")
            b-icon(icon="account" size="is-small")
            | &nbsp;&nbsp;&nbsp;
            | {{e.name_with_grade}} 情報

    b-dropdown-item(:separator="true")

    template(v-if="record.show_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="`${record.show_path}.kif`")
          b-icon(icon="download" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | KIF ダウンロード

    template(v-if="record.show_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="`${record.show_path}.ki2`")
          b-icon(icon="download" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | KI2 ダウンロード

    template(v-if="record.kifu_copy_params")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(@click="$root.kifu_copy_handle(Object.assign({}, record.kifu_copy_params, {kc_format: 'ki2'}))")
          b-icon(icon="clipboard-outline" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | KI2 コピー

    // @click.stop にするとURLをコピーしたあとプルダウンが閉じなくなる
    template(v-if="record.tweet_modal_url")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(@click="$root.modal_url_copy")
          b-icon(icon="clipboard-outline" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | URLをコピー

    template(v-if="in_modal")
      template(v-if="record.tweet_modal_url")
        b-dropdown-item(:has-link="true" :paddingless="true")
          a(@click="$root.modal_url_with_turn_copy")
            b-icon(icon="clipboard-outline" size="is-small")
            | &nbsp;&nbsp;&nbsp;
            | 現在の手数のURLをコピー

    b-dropdown-item(:separator="true")

    template(v-if="record.edit_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="`${record.edit_path}?mode=ogp`")
          b-icon(icon="settings-outline" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | OGP画像設定

    template(v-if="record.tweet_window_url")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="record.tweet_window_url" target="_blank")
          b-icon(icon="twitter" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | ツイート

    template(v-if="record.swars_real_battle_url")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="record.swars_real_battle_url" target="_blank")
          b-icon(icon="link" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | ウォーズに移動

    template(v-if="record.wars_tweet_body")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(@click="wars_tweet_copy_click(record.wars_tweet_body)")
          b-icon(icon="clipboard-outline" size="is-small")
          | &nbsp;&nbsp;&nbsp;
          | ウォーズ側のTweetコピー

</template>

<script>

export default {
  props: {
    record:   { required: true },
    in_modal: { },
  },
  methods: {
  },
}
</script>
