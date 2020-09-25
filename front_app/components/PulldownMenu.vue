<template lang="pug">
// td が text-align: right なため、その影響で右よりになってしまう。それを防ぐため append-to-body している
b-dropdown.PulldownMenu(:hoverable="false" :position="in_modal_p ? 'is-top-left' : 'is-bottom-left'" append-to-body)
  b-button(slot="trigger" icon-left="menu" size="is-small")

  b-dropdown-item(v-if="new_permalink_url" :href="tweet_intent_url(new_permalink_url)")
    b-icon(icon="twitter" size="is-small" type="is-info")
    | ツイート {{turn_mark}}

  b-dropdown-item(:href="share_board_url")
    b-icon(icon="apps" size="is-small")
    | 共有将棋盤で開く {{turn_mark}}

  b-dropdown-item(v-if="development_p && new_permalink_url" :href="new_permalink_url")
    b-icon(icon="link-variant" size="is-small")
    | パーマリンク {{turn_mark}}

  b-dropdown-item(v-if="development_p && new_permalink_url" @click="clipboard_copy({text: new_permalink_url})")
    b-icon(icon="link-variant-plus" size="is-small")
    | パーマリンクコピー {{turn_mark}}

  //- template(v-if="record.memberships" v-for="e in record.memberships")
  //-   b-dropdown-item(v-if="e.player_info_path" :href="e.player_info_path")
  //-     b-icon(icon="account" size="is-small")
  //-     | {{e.name_with_grade}} 情報

  //- b-dropdown-item(separator)

  b-dropdown-item(:href="`${record.show_path}?formal_sheet=true`")
    b-icon(icon="pdf-box" size="is-small")
    | 棋譜用紙

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

    ////////////////////////////////////////////////////////////////////////////////

    b-dropdown-item(separator)

    b-dropdown-item(:href="`${record.show_path}.png?attachment=true&width=&flip=${new_flip}&turn=${turn_offset}`")
      b-icon(icon="download" size="is-small")
      | PNG ダウンロード {{turn_mark}}

    b-dropdown-item(:href="`${record.show_path}.bod?attachment=true`")
      b-icon(icon="download" size="is-small")
      | BOD ダウンロード {{turn_mark}}

    b-dropdown-item(:href="`${record.show_path}.kif?attachment=true`")
      b-icon(icon="download" size="is-small")
      | KIF ダウンロード

    b-dropdown-item(:href="`${record.show_path}.ki2?attachment=true`")
      b-icon(icon="download" size="is-small")
      | KI2 ダウンロード

    b-dropdown-item(:href="`${record.show_path}.csa?attachment=true&turn=${turn_offset}`")
      b-icon(icon="download" size="is-small")
      | CSA ダウンロード

    b-dropdown-item(:href="`${record.show_path}.sfen?attachment=true`")
      b-icon(icon="download" size="is-small")
      | SFEN ダウンロード

    ////////////////////////////////////////////////////////////////////////////////

    b-dropdown-item(separator)

    b-dropdown-item(:href="`${record.show_path}.png?width=&flip=${new_flip}&turn=${turn_offset}`")
      b-icon(icon="eye" size="is-small")
      | PNG 表示 {{turn_mark}}

    b-dropdown-item(:href="`${record.show_path}.bod?turn=${turn_offset}`")
      b-icon(icon="eye" size="is-small")
      | BOD 表示 {{turn_mark}}

    b-dropdown-item(:href="`${record.show_path}.kif`")
      b-icon(icon="eye" size="is-small")
      | KIF 表示

    b-dropdown-item(:href="`${record.show_path}.ki2`")
      b-icon(icon="eye" size="is-small")
      | KI2 表示

    b-dropdown-item(:href="`${record.show_path}.csa`")
      b-icon(icon="eye" size="is-small")
      | CSA 表示

    b-dropdown-item(:href="`${record.show_path}.sfen`")
      b-icon(icon="eye" size="is-small")
      | SFEN 表示

    ////////////////////////////////////////////////////////////////////////////////

  b-dropdown-item(v-if="development_p" custom paddingless)
    pre
      | flip: {{flip}}
      | record.flip: {{record.flip}}
      | new_flip: {{new_flip}}
      | new_permalink_url: {{new_permalink_url}}
</template>

<script>
export default {
  props: {
    record:        { required: true },
    in_modal_p:    { },
    permalink_url: { required: false, },
    turn_offset:   { },
    flip:          { }, // かならず record.flip を渡してもらう
  },

  data() {
    return {
      expand_more: false,
    }
  },

  computed: {
    // 棋譜検索一覧では modal_on_index_path を使う
    // sp_show では渡された permalink_url を使う
    new_permalink_url() {
      return this.permalink_url || this.as_full_url(this.record.modal_on_index_path)
    },

    new_flip() {
      // 引数が明示的に渡されたときにはそれに従う。sp_show からのみ flip が動的に渡されている
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

    share_board_url() {
      const url = new URL(this.as_full_url("/share-board"))
      url.searchParams.set("body", this.record.sfen_body)
      url.searchParams.set("title", this.record.description)
      url.searchParams.set("turn", this.turn_offset)
      return url.toString()
    },
  },
}
</script>

<style lang="sass">
.PulldownMenu
  // バーガーボタンの面積を大きくする
  .dropdown-trigger
    .button
      padding: 0 1.25rem

  // アイコンと文章を離す
  .icon
    margin-right: 0.5rem
</style>
