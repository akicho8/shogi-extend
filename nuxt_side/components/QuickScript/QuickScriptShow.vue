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
          NavbarItemHome(icon="chevron-left" :to="{name: 'bin-qs_group_key-qs_page_key', params: {qs_group_key: current_qs_group}}")
        b-navbar-item(tag="nuxt-link" :to="{}" @click.native="reset_handle" v-if="meta.title")
          h1.has-text-weight-bold {{meta.title}}

      template(slot="end")
        NavbarItemLogin
        NavbarItemProfileLink
        //- NavbarItemSidebarOpen(@click="sidebar_toggle")

    MainSection
      .container.is-fluid
        .columns.is-multiline(v-if="params.form_method")
          .column.is-12
            template(v-if="params.form_parts")
              template(v-for="form_part in params.form_parts")
                b-field(:label="form_part.label" custom-class="is-small")
                  template(v-if="false")
                  template(v-else-if="form_part.type === 'string'")
                    b-input(
                      size="is-small"
                      :value="attr_value(form_part)"
                      @input="value => attr_update(form_part, value)"
                      :placeholder="form_part.placeholder"
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

            b-field(v-if="params.form_method === 'get'")
              .control
                b-button.get_handle(@click="get_handle" type="is-primary")
                  | {{params.button_label}}

            b-field(v-if="params.form_method === 'post'")
              .control
                form(method="POST" @submit.prevent="post_handle")
                  b-button.post_handle(native-type="submit" type="is-danger")
                    | {{params.button_label}}

        .columns.is-multiline(v-if="params.body")
          .column
            QuickScriptShowValue(:value="params.body")

        .columns.is-multiline(v-if="development_p")
          .column
            pre
              | {{attributes}}

    DebugBox.is-hidden-mobile(v-if="development_p")
      | {{value_type_guess(params.body)}}
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import Vue from 'vue'

export default {
  // scrollToTop: true,
  name: "QuickScriptShow",
  provide() {
    return {
      TheQS: this,
    }
  },
  props: {
    // 呼び出す側で $route.params を上書きすればいいのでこれはいらないかもしれない。
    qs_group_key: { type: String },
    qs_page_key:   { type: String },
  },
  data() {
    return {
      attributes: {},           // form 入力値
      params: null,             // サーバーから受け取った値(フリーズしたい)
      // meta: null,
    }
  },
  watch: {
    "$route.query": "$fetch",   // クエリ部分(例えば page=1 など)が $router.push で変化したとき $fetch を呼ぶ
  },
  // true にするとソースを読むとしたときも fetch() が呼ばれてタイトルが埋め込まれている
  // しかし http://localhost:4000/script/dev に SSR でアクセスできなくなる
  fetchOnServer: false,
  fetch() {
    return this.$axios.$get(this.current_api_path, {params: {...this.$route.query, _setup: true}}).then(params => this.params_receive(params))

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
    params_receive(params) {
      // ここはさらに server か client かで分けないといけない？

      // メッセージ
      if (_.isPlainObject(params.flash)) {
        this.toast_ok(params.flash["notice"])
        this.toast_ng(params.flash["alert"])
      }

      // リダイレクト
      // CSV にリダイレクトした場合などは現在のページが更新されないため redirect_to が入っているからといって return してはいけない。
      const redirect_to = params["redirect_to"]
      if (redirect_to) {
        if (redirect_to["allow_other_host"]) {
          window.location.href = redirect_to["to"]
        } else {
          this.$router.push(redirect_to["to"])
        }
        // ここで return するべからず
      }

      // 受けとる
      this.params = params

      // フォームの初期値を埋める
      if (this.params.form_parts) {
        this.params.form_parts.forEach(form_part => {
          this.$set(this.attributes, form_part["key"], form_part["default"])
        })
      }
    },

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
      this.router_push(params)
    },

    get_handle() {
      const params = {}
      if (this.params.params_add_submit_key) {
        params[this.params.params_add_submit_key] = true
      }
      if (this.params.get_then_router_push) {
        this.router_push(params)
      } else {
        this.$sound.play_click()
        const new_params = {...this.$route.query, ...this.attributes, ...params}
        this.$axios.$get(this.current_api_path, {params: params}).then(params => this.params_receive(params))
      }
    },

    post_handle() {
      const new_params = {...this.$route.query, ...this.attributes}
      this.$axios.$post(this.current_api_path, new_params).then(params => this.params_receive(params))
    },

    router_push(params = {}) {
      const new_params = {...this.$route.query, ...this.attributes, ...params}
      this.$router.push({query: new_params}, () => {
        this.debug_alert("Navigation succeeded")
        this.$sound.play_click()
      }, () => {
        this.debug_alert("Navigation failed")
        if (this.params.router_push_failed_then_fetch) {
          this.$sound.play_click()
          this.$fetch()
        }
      })
    },

    value_type_guess(value) {
      if (Array.isArray(value)) {
        if (_.isPlainObject(value[0])) {
          return "value_type_is_hash_array"
        }
        return "value_type_is_text_array"
      }
      if (typeof(value) === "string") {
        if (value.startsWith("<")) {
          return "value_type_is_html"
        }
        return "value_type_is_text"
      }
      if (_.isPlainObject(value)) {
        if (value["_component"]) {
          return "value_type_is_component"
        }
        if (value["_nuxt_link"]) {
          return "value_type_is_nuxt_link"
        }
        if (value["_link_to"]) {
          return "value_type_is_link_to"
        }
        if (value["_v_text"]) {
          return "value_type_is_v_text"
        }
        if (value["_pre"]) {
          return "value_type_is_pre"
        }
        if (value["_autolink"]) {
          return "value_type_is_autolink"
        }
        return "value_type_is_any_hash"
      }
      return "value_type_is_unknown"
    },

    value_wrap(value) {
      return value
    },
  },
  computed: {
    current_qs_group()   { return this.qs_group_key ?? this.$route.params.qs_group_key                                                               },
    current_qs_key()     { return this.qs_page_key   ?? this.$route.params.qs_page_key                                                                 },
    current_api_path() { return `/api/bin/${this.current_qs_group ?? '__qs_group_is_blank__'}/${this.current_qs_key ?? '__qs_page_key_is_blank__'}.json` },
    meta()             { return this.params ? this.params.meta : null                                                                  },
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

.STAGE-development
  .QuickScriptShow
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
