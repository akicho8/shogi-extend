<template lang="pug">
.QuickScriptShow
  b-loading(:active="$fetchState.pending")
  template(v-if="params")
    MainNavbar(wrapper-class="container is-fluid")
      template(slot="brand")
        NavbarItemHome
        b-navbar-item(tag="nuxt-link" :to="{}" @click.native="reset_handle" v-if="params.meta.title")
          h1.has-text-weight-bold {{params.meta.title}}

      template(slot="end")
        NavbarItemLogin
        NavbarItemProfileLink
        //- NavbarItemSidebarOpen(@click="sidebar_toggle")

    MainSection
      .container.is-fluid
        .columns
          .column
            template(v-for="form_part in params.form_parts")
              b-field(:label="form_part.label")
                template(v-if="false")
                template(v-else-if="form_part.type === 'string'")
                  b-input(
                    size="is-small"
                    :value="attr_value(form_part)"
                    @input="value => attr_update(form_part, value)"
                    )
                template(v-else-if="form_part.type === 'integer'")
                  b-numberinput(
                    size="is-small"
                    :value="attr_value(form_part)"
                    @input="value => attr_update(form_part, value)"
                    controls-position="compact"
                    :exponential="true"
                    )
                template(v-else-if="form_part.type === 'select'")
                  b-select(
                    size="is-small"
                    :value="attr_value(form_part)"
                    @input="value => attr_update(form_part, value)"
                    )
                    template(v-for="elem in form_part.elems")
                      option(:value="elem") {{elem}}
                template(v-else)
                  pre unknown: {{form_part.type}}

            div(v-if="params.get_button_show_p")
              b-button.submit_handle(@click="submit_handle" type="is-primary") {{params.button_label}}

            template(v-if="false")
            template(v-else-if="body_layout_guess === 'raw_html'")
              div(v-html="params.body")
            template(v-else-if="body_layout_guess === 'pre_string'")
              pre {{params.body}}
            template(v-else-if="body_layout_guess === 'escaped_string'")
              | {{params.body}}
            template(v-else-if="body_layout_guess === 'hash_array_table'")
              b-table(
                :data="params.body"
                )
                template(v-for="column_name in column_names")
                  b-table-column(v-slot="{row}" :field="column_name" :label="column_name")
                    //- nuxt-link(to="/share-board") foo1
                    //- nuxt-link(to="http://localhost:4000/share-board") foo2
                    //- nuxt-link(to="https://example.com/") foo3
                    template(v-if="false")
                    template(v-else-if="value_type(row[column_name]) === 'outside_full_url'")
                      div(v-html="$gs.auto_link(row[column_name])")
                    template(v-else-if="value_type(row[column_name]) === 'inside_url'")
                      nuxt-link(:to="row[column_name]['_nuxt_link'].to") {{row[column_name]['_nuxt_link'].name}}
                    template(v-else)
                      | {{row[column_name]}}
            template(v-else)
              pre {{params.body}}

        .columns
          .column
            pre(v-if="development_p")
              | {{attributes}}

            DebugBox.is-hidden-mobile(v-if="development_p")
              | body_layout_guess: {{body_layout_guess}}

            //- pre attributes = {{attributes}}

            //- pre posts = {{posts}}

            //- pre(v-if="development_p")
            //-   | params: {{params}}
            //-   | $data: {{$data}}
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import Vue from 'vue'

export default {
  name: "QuickScriptShow",
  mixins: [],
  provide() {
    return {
      TheQS: this,
    }
  },
  data() {
    return {
      attributes: {},           // form 入力値
      params: null,             // サーバーから受け取った値(フリーズしたい)
      meta: null,
    }
  },
  watch: {
    "$route.query": "$fetch",
  },
  // true にするとソースを読むとしたときも fetch() が呼ばれてタイトルが埋め込まれている
  // しかし http://localhost:4000/script/dev に SSR でアクセスできなくなる
  fetchOnServer: false,
  fetch() {
    const skey = this.$route.params.skey ?? "__skey_is_blank_then_index_show__"
    const api_path = `/api/script/${this.$route.params.sgroup}/${skey}`
    return this.$axios.$get(api_path, {params: this.$route.query}).then(params => {
      // ここはさらに server か client かで分けないといけない？

      // 最優先でリダイレクトする
      // 外部
      if (Gs.present_p(params.body["href_redirect_to"])) {
        window.location.href = params.body["href_redirect_to"]
        // redirect(params.body["href_redirect_to"])
        // this.$router.push(params.body["href_redirect_to"]) // ← 動かない
        return
      }

      // サイト内
      if (Gs.present_p(params.body["router_redirect_to"])) {
        this.$router.push(params.body["router_redirect_to"])
        return
      }

      // 受けとる
      this.meta = params["meta"] // ページタイトルを更新するため
      this.params = params

      // 初期値を埋める
      this.params.form_parts.forEach(form_part => {
        this.$set(this.attributes, form_part["key"], form_part["default"])
      })
    }).catch(error => {
      // エラーレスポンスの処理
      if (error.response) {
        // サーバーからのレスポンスがある場合
        const status = error.response.status
        const data = error.response.data

        if (status === 400) {
          console.error('Bad Request:', data)
        } else if (status === 401) {
          console.error('Unauthorized:', data)
          this.$router.push('/login') // ログインページにリダイレクト
        } else if (status === 404) {
          console.error('Not Found:', data)
          this.$router.push('/not-found') // カスタム404ページにリダイレクト
        } else if (status === 500) {
          console.error('Internal Server Error:', data)
        } else {
          console.error('Error:', data)
        }
      } else {
        // サーバーからのレスポンスがない場合（ネットワークエラーなど）
        console.error('Network Error:', error.message)
      }
    })
  },
  created() {
    console.debug(this.$route)
  },
  beforeMount() {
  },
  mounted() {
  },
  methods: {
    reset_handle() {
    },

    attr_value(form_part) {
      return this.attributes[form_part.key]
    },
    attr_update(form_part, value) {
      this.$set(this.attributes, form_part.key, value)
    },
    submit_handle() {
      // const router_options = {name: "script-sgroup-skey", params: {sgroup: this.params["sgroup"], skey: this.params["skey"]}, query: this.attributes}
      const router_options = {query: this.attributes} // 現在のURLに飛ぶのであれば query だけでよい
      this.$router.push(router_options, () => {
        this.$sound.play_click()
        console.log("Navigation succeeded")
      }, () => {
        console.log("Navigation failed")
        // window.location.href = this.$router.resolve(router_options).href
      })
    },

    value_type(value) {
      if (typeof(value) === "string") {
        if (value.match(/^http/)) {
          return "outside_full_url"
        }
      }
      if (_.isPlainObject(value)) {
        if (Gs.present_p(value["_nuxt_link"])) {
          return "inside_url"
        }
      }
    },

    value_wrap(value) {
      return value
    },
  },
  computed: {
    body_layout_guess() {
      if (this.params) {
        if (this.params.body_layout === "auto") {
          if (Array.isArray(this.params.body)) {
            if (_.isPlainObject(this.params.body[0])) {
              return "hash_array_table"
            }
          }
        } else {
          return this.params.body_layout
        }
      }
    },

    column_names() {
      if (this.body_layout_guess === "hash_array_table") {
        const hv = {}
        this.params.body.forEach(e => {
          _.each(e, (v, k) => { hv[k] = true })
        })
        return Object.keys(hv)
      }
    },
  },
}
</script>

<style lang="sass">
.QuickScriptShow
  .MainSection.section
    +tablet
      padding: 1.75rem 0rem

  .container
    +mobile
      padding: 0

  .b-table
    margin-top: 0rem
    // margin-bottom: 2rem
    +mobile
      margin-top: 1rem
    td
      vertical-align: middle

.STAGE-development
  .QuickScriptShow
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
