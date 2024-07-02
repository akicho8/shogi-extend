<template lang="pug">
.QuickScriptShow
  template(v-if="development_p && false")
    b-loading(:active="$fetchState.pending")
  template(v-if="params")
    MainNavbar(wrapper-class="container is-fluid")
      template(slot="brand")
        template(v-if="$route.path === '/bin'")
          NavbarItemHome(icon="chevron-left" :to="{path: '/'}")
        template(v-else-if="current_qs_key == null")
          NavbarItemHome(icon="chevron-left" :to="{path: '/bin'}")
        template(v-else)
          NavbarItemHome(icon="chevron-left" :to="{name: 'bin-qs_group_key-qs_key', params: {qs_group_key: current_qs_group}}")
        b-navbar-item(tag="nuxt-link" :to="{}" @click.native="reset_handle" v-if="meta.title")
          h1.has-text-weight-bold {{meta.title}}

      template(slot="end")
        NavbarItemLogin
        NavbarItemProfileLink
        //- NavbarItemSidebarOpen(@click="sidebar_toggle")

    MainSection
      .container.is-fluid
        .columns.is-multiline
          .column.is-12
            template(v-if="params.form_parts")
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
            template(v-else-if="body_layout_guess === 'value_type_is_hash_array'")
              b-table(
                :data="params.body"
                scrollable
                pagination-simple
                backend-pagination
                :paginated    = "params.page_params.paginated"
                :total        = "params.page_params.total"
                :current-page = "params.page_params.current_page"
                :per-page     = "params.page_params.per_page"
                @page-change="(page) => page_change_or_sort_handle({page})"
                )
                template(v-for="column_name in column_names")
                  b-table-column(v-slot="{row}" :field="column_name" :label="column_name")
                    QuickScriptShowValue(:value="row[column_name]")
            template(v-else)
              QuickScriptShowValue(:value="params.body")

        .columns.is-multiline
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
  provide() {
    return {
      TheQS: this,
    }
  },
  props: {
    // 呼び出す側で $route.params を上書きすればいいのでこれはいらないかもしれない。
    qs_group_key: { type: String },
    qs_key:   { type: String },
  },
  data() {
    return {
      attributes: {},           // form 入力値
      params: null,             // サーバーから受け取った値(フリーズしたい)
      // meta: null,
    }
  },
  watch: {
    "$route.query": "$fetch",
  },
  // true にするとソースを読むとしたときも fetch() が呼ばれてタイトルが埋め込まれている
  // しかし http://localhost:4000/script/dev に SSR でアクセスできなくなる
  fetchOnServer: false,
  fetch() {
    return this.$axios.$get(this.current_api_path, {params: this.$route.query}).then(params => {
      // ここはさらに server か client かで分けないといけない？

      if (_.isPlainObject(params.body)) { // params.body が nil の場合があるため
        // 最優先でリダイレクトする

        // 外部
        {
          const value = params.body["href_redirect_to"]
          if (Gs.present_p(value)) {
            window.location.href = value
            // redirect(params.body["href_redirect_to"])
            // this.$router.push(params.body["href_redirect_to"]) // ← 動かない
            return
          }
        }

        // サイト内
        {
          const value = params.body["router_redirect_to"]
          if (Gs.present_p(value)) {
            this.$router.push(value)
            return
          }
        }
      }

      // 受けとる
      this.params = params

      // 初期値を埋める
      if (this.params.form_parts) {
        this.params.form_parts.forEach(form_part => {
          this.$set(this.attributes, form_part["key"], form_part["default"])
        })
      }
    })

    // }).catch(error => {
    //   // エラーレスポンスの処理
    //   if (error.response) {
    //     // サーバーからのレスポンスがある場合
    //     const status = error.response.status
    //     const data = error.response.data
    //
    //     if (status === 400) {
    //       console.error('Bad Request:', data)
    //     } else if (status === 401) {
    //       console.error('Unauthorized:', data)
    //       this.$router.push('/login') // ログインページにリダイレクト
    //     } else if (status === 404) {
    //       console.error('Not Found:', data)
    //       this.$router.push('/not-found') // カスタム404ページにリダイレクト
    //     } else if (status === 500) {
    //       console.error('Internal Server Error:', data)
    //     } else {
    //       console.error('Error:', data)
    //     }
    //   } else {
    //     // サーバーからのレスポンスがない場合（ネットワークエラーなど）
    //     console.error('Network Error:', error.message)
    //   }
    // })
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

    // b-table の @sort と @page-change に反応
    page_change_or_sort_handle(params) {
      this.page_update(params)
    },

    submit_handle() {
      this.page_update()
    },

    page_update(append_params = {}) {
      const new_params = {...this.attributes, ...append_params}
      this.$router.push({query: new_params}, () => {
        this.$sound.play_click()
        console.log("Navigation succeeded")
      }, () => {
        console.log("Navigation failed")
        // window.location.href = this.$router.resolve(new_params).href
      })
    },

    value_type_guess(value) {
      if (Array.isArray(value)) {
        if (_.isPlainObject(value[0])) {
          return "value_type_is_hash_array"
        }
        return "value_type_is_string_array"
      }
      if (typeof(value) === "string") {
        if (value.startsWith("<")) {
          return "value_type_is_beginning_html_tag"
        }
      }
      if (_.isPlainObject(value)) {
        if (value["_nuxt_link"]) {
          return "value_type_is_nuxt_link"
        }
        if (value["_link_to"]) {
          return "value_type_is_link_to"
        }
        if (value["_v_text"]) {
          return "value_type_is_v_text"
        }
        return "value_type_is_any_hash"
      }
    },

    value_wrap(value) {
      return value
    },
  },
  computed: {
    current_qs_group()   { return this.qs_group_key ?? this.$route.params.qs_group_key                                                               },
    current_qs_key()     { return this.qs_key   ?? this.$route.params.qs_key                                                                 },
    current_api_path() { return `/api/bin/${this.current_qs_group ?? '__qs_group_is_blank__'}/${this.current_qs_key ?? '__skey_is_blank__'}` },
    meta()             { return this.params ? this.params.meta : null                                                                  },

    body_layout_guess() {
      if (this.params) {
        if (this.params.body_guess == null) {
          return this.value_type_guess(this.params.body)
        }
        return this.params.body_guess
      }
    },

    column_names() {
      if (this.body_layout_guess === "value_type_is_hash_array") {
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
