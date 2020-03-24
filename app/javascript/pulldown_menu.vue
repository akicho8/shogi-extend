<template lang="pug">
b-dropdown.pulldown_menu(:hoverable="false" :position="in_modal_p ? 'is-top-left' : 'is-bottom-left'")
  b-button(slot="trigger" icon-left="menu" size="is-small")

  b-dropdown-item(v-if="new_permalink_url" :href="tweet_url_for(new_permalink_url)")
    b-icon(icon="twitter" size="is-small" type="is-info")
    | ツイート {{turn_mark}}

  b-dropdown-item(v-if="record.show_path" :href="`${record.show_path}.png?attachment=true&width=&flip=${new_flip}&turn=${turn_offset}`")
    b-icon(icon="download" size="is-small")
    | 画像ダウンロード {{turn_mark}}

  b-dropdown-item(v-if="new_permalink_url" :href="new_permalink_url")
    b-icon(icon="link-variant" size="is-small")
    | リンクURL {{turn_mark}}

  b-dropdown-item(v-if="new_permalink_url" @click="clipboard_copy({text: new_permalink_url})")
    b-icon(icon="link-variant-plus" size="is-small")
    | リンクURLコピー {{turn_mark}}

  template(v-if="record.memberships" v-for="e in record.memberships")
    b-dropdown-item(v-if="e.player_info_path" :href="e.player_info_path")
      b-icon(icon="account" size="is-small")
      | {{e.name_with_grade}} 情報

  //- b-dropdown-item(separator)

  //- template(v-if="record.show_path")
  //-   b-dropdown-item()
  //-     a(:href="`${record.show_path}.ki2?attachment=true`")
  //-       b-icon(icon="download" size="is-small")
  //-       | KI2 ダウンロード
  //-
  //- template(v-if="record.kifu_copy_params")
  //-   b-dropdown-item()
  //-     a(@click="kif_clipboard_copy(ki2_copy_params)")
  //-       b-icon(icon="clipboard-plus-outline" size="is-small")
  //-       | KI2 コピー

  b-dropdown-item(v-if="record.show_path" :href="`${record.show_path}.kif?attachment=true`")
    b-icon(icon="download" size="is-small")
    | KIF ダウンロード

  b-dropdown-item(v-if="record.show_path" :href="`${record.show_path}.kif`")
    b-icon(icon="eye" size="is-small")
    | KIF 表示

  b-dropdown-item(:v-if="record.show_path" :href="`${record.show_path}.png?width=&flip=${new_flip}&turn=${turn_offset}`")
    b-icon(icon="eye" size="is-small")
    | 画像 表示 {{turn_mark}}

  b-dropdown-item(separator v-if="false")

  b-dropdown-item.dropdown-item
    div(@click.stop="expand_more = !expand_more")
      b-icon(:icon="expand_more ? 'chevron-up' : 'chevron-down'" size="is-small")
      template(v-if="expand_more")
        | もっと見ない
      template(v-else)
        | もっと見る

  template(v-if="expand_more")
    b-dropdown-item(v-if="development_p && record.show_path" :href="record.show_path")
      b-icon(icon="play" size="is-small")
      | 詳細

    b-dropdown-item(v-if="record.edit_path" :href="record.edit_path")
      b-icon(icon="pencil" size="is-small")
      | 編集

    b-dropdown-item(v-if="record.new_and_copy_url" :href="record.new_and_copy_url")
      b-icon(icon="link" size="is-small")
      | コピペ新規

    b-dropdown-item(:v-if="record.show_path" :href="`${record.show_path}.ki2`")
      b-icon(icon="eye" size="is-small")
      | KI2 表示

    b-dropdown-item(:v-if="record.show_path" :href="`${record.show_path}.csa`")
      b-icon(icon="eye" size="is-small")
      | CSA 表示

    b-dropdown-item(:v-if="record.show_path" :href="`${record.show_path}.sfen`")
      b-icon(icon="eye" size="is-small")
      | SFEN 表示

    b-dropdown-item(v-if="record.formal_sheet_path" :href="record.formal_sheet_path")
      b-icon(icon="pdf-box" size="is-small")
      | 棋譜用紙

  b-dropdown-item(v-if="development_p" custom paddingless)
    pre
      | flip: {{flip}}
      | record.flip: {{record.flip}}
      | new_flip: {{new_flip}}
      | new_permalink_url: {{new_permalink_url}}

  //- // @click.stop にするとURLをコピーしたあとプルダウンが閉じなくなる
  //- template(v-if="record.modal_on_index_url")
  //-   b-dropdown-item()
  //-     a(@click="clipboard_copy({text: record.modal_on_index_url})")
  //-       b-icon(icon="clipboard-plus-outline" size="is-small")
  //-       | URLをコピー
  //-
  //- template(v-if="in_modal_p")
  //-   template(v-if="record.modal_on_index_url")
  //-     template(v-if="turn_offset != null")
  //-       b-dropdown-item()
  //-         a(@click="clipboard_copy({text: `${record.modal_on_index_url}&turn=${turn_offset}`})")
  //-           b-icon(icon="clipboard-plus-outline" size="is-small")
  //-           | URLをコピー \#{{turn_offset}}

  //- template(v-if="record.official_swars_battle_url")
  //-   b-dropdown-item()
  //-     a(:href="record.official_swars_battle_url" target="_self")
  //-       b-icon(icon="link" size="is-small")
  //-       | ウォーズに飛ぶ
  //-
  //- template(v-if="record.swars_tweet_text")
  //-   b-dropdown-item()
  //-     a(@click="simple_clipboard_copy(record.swars_tweet_text)")
  //-       b-icon(icon="clipboard-plus-outline" size="is-small")
  //-       | ウォーズ側のTweetコピー
</template>

<script>
export default {
  props: {
    record:        { required: true },
    in_modal_p:    { },
    permalink_url: { },
    turn_offset:   { },
    flip:          { }, // かならず record.flip を渡してもらう
  },

  data() {
    return {
      ki2_copy_params: null, // モバイルのとき1回目が失敗するのでそのときに棋譜を保存する
      expand_more: false,
    }
  },

  created() {
    this.ki2_copy_params = {...this.record.kifu_copy_params, kc_format: 'ki2'}
  },

  methods: {
  },

  computed: {
    new_permalink_url() {
      // sp_modal で作られた permalink_url を使うが、なければコントローラーで埋められたのを使う
      return this.permalink_url || this.record.modal_on_index_url
    },

    new_flip() {
      // 引数が明示的に渡されたときにはそれに従う。sp_modal からのみ flip が動的に渡されている
      if (this.flip != null) {
        return this.flip
      }

      // コントローラーで record に埋められたのを使う
      return this.record.flip
    },

    turn_mark() {
      let v = `#${this.turn_offset}`

      if (this.development_p) {
        if (this.new_flip) {
          v = `-${v}`
        }
      }

      return v
    },
  },
}
</script>

<style lang="sass">
@import "stylesheets/bulma_init.scss"
.pulldown_menu
  // バーガーボタンの面積を大きくする
  .dropdown-trigger
    .button
      padding: 0 1.25rem

  // アイコンと文章を離す
  .icon
    margin-right: 0.5rem
</style>
