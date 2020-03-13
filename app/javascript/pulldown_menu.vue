<template lang="pug">
  b-dropdown(:hoverable="false" :position="in_modal_p ? 'is-top-left' : 'is-bottom-left'")
    b-button(slot="trigger" icon-left="menu" size="is-small")

    template(v-if="new_permalink_url")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="tweet_url_for(new_permalink_url)")
          b-icon(icon="twitter" size="is-small" type="is-info")
          span.a_label
            | ツイート {{turn_mark}}

    template(v-if="record.show_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="`${record.show_path}.png?attachment=true&turn=${turn_offset}`")
          b-icon(icon="download" size="is-small")
          span.a_label PNG ダウンロード {{turn_mark}}

    template(v-if="new_permalink_url")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="new_permalink_url")
          b-icon(icon="open-in-new" size="is-small")
          span.a_label
            | パーマリンク {{turn_mark}}

    //- template(v-if="record.show_path")
    //-   b-dropdown-item(:has-link="true" :paddingless="true")
    //-     a(:href="record.show_path")
    //-       b-icon(icon="play" size="is-small")
    //-       span.a_label 詳細

    template(v-if="record.edit_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="record.edit_path")
          b-icon(icon="pencil" size="is-small")
          span.a_label 編集

    template(v-if="record.new_and_copy_url")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="record.new_and_copy_url")
          b-icon(icon="open-in-new" size="is-small")
          span.a_label コピペ新規

    template(v-if="record.memberships")
      template(v-for="e in record.memberships")
        template(v-if="e.player_info_path")
          b-dropdown-item(:has-link="true" :paddingless="true")
            a(:href="e.player_info_path")
              b-icon(icon="account" size="is-small")
              span.a_label {{e.name_with_grade}} 情報

    //- b-dropdown-item(:separator="true")

    //- template(v-if="record.show_path")
    //-   b-dropdown-item(:has-link="true" :paddingless="true")
    //-     a(:href="`${record.show_path}.ki2?attachment=true`")
    //-       b-icon(icon="download" size="is-small")
    //-       span.a_label KI2 ダウンロード
    //-
    //- template(v-if="record.kifu_copy_params")
    //-   b-dropdown-item(:has-link="true" :paddingless="true")
    //-     a(@click="kif_clipboard_copy(ki2_copy_params)")
    //-       b-icon(icon="clipboard-plus-outline" size="is-small")
    //-       span.a_label KI2 コピー

    b-dropdown-item(:separator="true")

    template(v-if="record.show_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="`${record.show_path}.kif?attachment=true`")
          b-icon(icon="download" size="is-small")
          span.a_label KIF ダウンロード

    b-dropdown-item(:separator="true")

    template(v-if="record.show_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="`${record.show_path}.kif`")
          b-icon(icon="eye" size="is-small")
          span.a_label KIF 表示

    template(v-if="record.show_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="`${record.show_path}.ki2`")
          b-icon(icon="eye" size="is-small")
          span.a_label KI2 表示

    template(v-if="record.show_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="`${record.show_path}.csa`")
          b-icon(icon="eye" size="is-small")
          span.a_label CSA 表示

    template(v-if="record.show_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="`${record.show_path}.sfen`")
          b-icon(icon="eye" size="is-small")
          span.a_label SFEN 表示

    template(v-if="record.show_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="`${record.show_path}.png?width=&turn=${turn_offset}`")
          b-icon(icon="eye" size="is-small")
          span.a_label PNG 表示 {{turn_mark}}

    b-dropdown-item(:separator="true")

    template(v-if="record.formal_sheet_path")
      b-dropdown-item(:has-link="true" :paddingless="true")
        a(:href="record.formal_sheet_path" target="_self")
          b-icon(icon="pdf-box" size="is-small")
          span.a_label 棋譜用紙

    //- // @click.stop にするとURLをコピーしたあとプルダウンが閉じなくなる
    //- template(v-if="record.modal_on_index_url")
    //-   b-dropdown-item(:has-link="true" :paddingless="true")
    //-     a(@click="clipboard_copy({text: record.modal_on_index_url})")
    //-       b-icon(icon="clipboard-plus-outline" size="is-small")
    //-       span.a_label URLをコピー
    //-
    //- template(v-if="in_modal_p")
    //-   template(v-if="record.modal_on_index_url")
    //-     template(v-if="turn_offset != null")
    //-       b-dropdown-item(:has-link="true" :paddingless="true")
    //-         a(@click="clipboard_copy({text: `${record.modal_on_index_url}&turn=${turn_offset}`})")
    //-           b-icon(icon="clipboard-plus-outline" size="is-small")
    //-           span.a_label URLをコピー \#{{turn_offset}}

    //- b-dropdown-item(:separator="true")
    //-
    //- template(v-if="record.edit_path")
    //-   b-dropdown-item(:has-link="true" :paddingless="true")
    //-     a(:href="`${record.edit_path}?edit_mode=ogp`")
    //-       b-icon(icon="settings-outline" size="is-small")
    //-       span.a_label OGP画像設定
    //-
    //- template(v-if="record.tweet_window_url")
    //-   b-dropdown-item(:has-link="true" :paddingless="true")
    //-     a(:href="record.tweet_window_url" target="_self")
    //-       b-icon(icon="twitter" size="is-small")
    //-       span.a_label ツイート
    //-
    //- template(v-if="record.official_swars_battle_url")
    //-   b-dropdown-item(:has-link="true" :paddingless="true")
    //-     a(:href="record.official_swars_battle_url" target="_self")
    //-       b-icon(icon="link" size="is-small")
    //-       span.a_label ウォーズに飛ぶ
    //-
    //- template(v-if="record.swars_tweet_text")
    //-   b-dropdown-item(:has-link="true" :paddingless="true")
    //-     a(@click="simple_clipboard_copy(record.swars_tweet_text)")
    //-       b-icon(icon="clipboard-plus-outline" size="is-small")
    //-       span.a_label ウォーズ側のTweetコピー
</template>

<script>
export default {
  props: {
    record:   { required: false },
    in_modal_p: { },
    permalink_url: { },
    turn_offset: { },
  },

  data() {
    return {
      ki2_copy_params: null,
    }
  },

  created() {
    this.ki2_copy_params = {...this.record.kifu_copy_params, kc_format: 'ki2'}
  },

  methods: {
  },

  computed: {
    new_permalink_url() {
      return this.permalink_url || this.record.modal_on_index_url
    },

    turn_mark() {
      return `#${this.turn_offset}`
    },
  },
}
</script>
