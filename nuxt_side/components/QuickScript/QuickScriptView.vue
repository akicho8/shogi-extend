<template lang="pug">
.QuickScriptView
  DebugBox(v-if="development_p" position="bottom_right")
    div g_loading_p (axios): {{g_loading_p}}
    div $fetchState.pending: {{$fetchState.pending}}
    div fetch_index: {{fetch_index}}

  template(v-if="development_p || true")
    //- b-loading(:active="$fetchState.pending || (params && params.button_click_loading && g_loading_p)")
    b-loading(:active="g_loading_p")

  template(v-if="params")
    MainNavbar(wrapper-class="container is-fluid" v-if="params.navibar_show")
      template(slot="brand")
        template(v-if="$route.path === '/bin'")
          // レベル1: サイトトップまで上がる
          NavbarItemHome(icon="chevron-left" :to="{path: '/'}")
        template(v-else-if="current_qs_key == null")
          // レベル2: グループ一覧を表示する
          NavbarItemHome(icon="chevron-left" :to="{path: '/bin'}")
        template(v-else)
          // レベル3: グループ内を表示する
          NavbarItemHome(icon="chevron-left" :to="{name: 'bin-qs_group_key-qs_page_key', params: {qs_group_key: current_qs_group}}")

        // タイトルをクリックしたときは query を外す
        b-navbar-item(tag="nuxt-link" :to="{}" @click.native="title_click_handle" v-if="meta.title")
          h1.has-text-weight-bold {{meta.title}}

      //- template(slot="end")
      //-   NavbarItemLogin
      //-   NavbarItemProfileLink
      //-   //- NavbarItemSidebarOpen(@click="sidebar_toggle")

    MainSection
      .container.is-fluid
        .columns.is-mobile.is-multiline(v-if="params.form_parts.length >= 1")
          .column.is-12
            template(v-for="form_part in params.form_parts")
              b-field(:label="form_part.label" custom-class="is-small" :message="form_part.help_message")
                template(v-if="false")
                template(v-else-if="form_part.type === 'string'")
                  b-input(
                    v-model="attributes[form_part.key]"
                    :placeholder="form_part.placeholder"
                    spellcheck="false"
                    )
                template(v-else-if="form_part.type === 'text'")
                  b-input(
                    type="textarea"
                    v-model="attributes[form_part.key]"
                    :placeholder="form_part.placeholder"
                    spellcheck="false"
                    )
                template(v-else-if="form_part.type === 'integer'")
                  b-numberinput(
                    v-model="attributes[form_part.key]"
                    controls-position="compact"
                    :exponential="true"
                    )
                template(v-else-if="form_part.type === 'select'")
                  b-select(
                    v-model="attributes[form_part.key]"
                    )
                    template(v-for="[label, value] in label_value_array(form_part.elems)")
                      option(:value="value") {{label}}
                template(v-else-if="form_part.type === 'radio_button' || form_part.type === 'checkbox_button'")
                  template(v-for="[label, value] in label_value_array(form_part.elems)")
                    component(:is="type_to_component(form_part)" v-model="attributes[form_part.key]" :native-value="value")
                      span {{label}}
                template(v-else)
                  pre unknown: {{form_part.type}}

            //- template(v-if="visible_form_parts_exist_p")
            //-   hr
        .columns.is-mobile.is-multiline(v-if="params.form_method")
          .column.is-12
            b-field(v-if="params.form_method === 'get'")
              .control
                form(method="GET" @submit.prevent="get_handle")
                  b-button.get_handle(native-type="submit" type="is-primary")
                    | {{params.button_label}}
              //- .control
              //-   b-button.get_handle(@click="get_handle" type="is-primary")
              //-     | {{params.button_label}}

            b-field(v-if="params.form_method === 'post'")
              .control
                form(method="POST" @submit.prevent="post_handle")
                  b-button.post_handle(native-type="submit" type="is-danger")
                    | {{params.button_label}}

        .columns.is-mobile.is-multiline(v-if="params.body")
          .column.is-12
            QuickScriptViewValue(:value="params.body")

        .columns.is-mobile.is-multiline(v-if="development_p")
          .column.is-12
            pre
              | {{attributes}}
            //- pre
            //-   | {{params}}

    DebugBox.is-hidden-mobile(v-if="development_p")
      | {{value_type_guess(params.body)}}
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import Vue from 'vue'

export default {
  // scrollToTop: true,
  name: "QuickScriptView",
  provide() {
    return {
      TheQS: this,
    }
  },
  props: {
    // 呼び出す側で $route.params を上書きすればいいのでこれはいらない。
    // が、一つのページで QuickScriptView を二つ呼ぶ場合には使えないので一応用意しておく。
    qs_group_key: { type: String },
    qs_page_key:  { type: String },
  },
  data() {
    return {
      attributes: {},      // form 入力値
      params: null,        // サーバーから受け取った値(更新禁止)
      fetch_index: null,
    }
  },
  watch: {
    // クエリ部分(例えば page=1 など)が $router.push で変化したとき $fetch を呼ぶ。
    "$route.query": "$fetch",
  },

  // https://qiita.com/crml1206/items/24bf29bc36566f4cc68d
  // true にするとソースを読むとしたときも fetch() が呼ばれてタイトルが埋め込まれている
  // しかし http://localhost:4000/bin/dev に SSR でアクセスできなくなる
  fetchOnServer: false,

  // async fetch({ $axios, error }) {
  //   try {
  //     const response = await $axios.$get(this.current_api_path, {params: {...this.$route.query, _setup: true}})
  //     console.log(response)
  //     this.params_receive(response)
  //   } catch (e) {
  //     if (e.response && e.response.status === 401) {
  //       console.log("401 エラーが発生した場合、クライアントサイドで再度 fetch する")
  //       return { retry: true };
  //     }
  //     // その他のエラーを処理
  //     error({ statusCode: e.response.status, message: e.message });
  //   }
  // },

  fetch() {
    // 初回以降も呼ばれるため attributes をまぜる
    // $route.query は初回のときに使い、this.attributes は次からのときに使う
    this.fetch_index ??= 0
    const new_params = this.new_params_create({__fetch_index__: this.fetch_index})
    this.$axios.$get(this.current_api_path, {params: new_params}).then(params => {
      this.fetch_index += 1
      this.params_receive(params)
    })
  },

  methods: {
    params_receive(params) {
      // fetchOnServer: true のときに実行すると this.toast_ok がないと言われる
      if (process.client) {
        // メッセージ
        // リダイレクトの前に設定すること
        if (_.isPlainObject(params.flash)) {
          this.toast_ok(params.flash["notice"])
          this.toast_ng(params.flash["alert"])
        }

        // リダイレクト
        // CSV にリダイレクトした場合などは現在のページから遷移しないため redirect_to が入っているからといって return してはいけない。
        const redirect_to = params["redirect_to"]
        if (redirect_to) {
          const to = redirect_to["to"]
          if (redirect_to["hard_jump"]) {
            window.location.href = to
          } else if (redirect_to["tab_open"]) {
            this.other_window_open(to)
          } else {
            this.$router.push(to)
          }
          // ここで return するべからず
        }
      }

      // 受けとる (と、このタイミングでユーザーは画面の更新に気づく)
      this.params = params

      // フォームの初期値を埋める
      if (this.params.form_parts) {
        this.params.form_parts.forEach(form_part => {
          // let value = form_part["default"]
          // if (form_part.type === "checkbox_button") {
          // }
          this.$set(this.attributes, form_part["key"], form_part["default"])
        })
      }

      // 最後に特定のメソッドを実行する
      // これは主に nuxt_login_required を呼ぶために用意してある
      const fetch_then_auto_exec_action = params["fetch_then_auto_exec_action"]
      if (fetch_then_auto_exec_action) {
        this[fetch_then_auto_exec_action]()
      }
    },

    title_click_handle() {
      //
    },

    attr_value(form_part) {
      return this.attributes[form_part.key]
    },
    attr_update(form_part, value) {
      this.$set(this.attributes, form_part.key, value)
    },

    new_params_create(params = {}) {
      return {...this.$route.query, ...this.attributes, ...params}
    },

    // b-table の @sort と @page-change に反応
    page_change_or_sort_handle(params) {
      this.router_push(params)
    },

    get_handle() {
      if (this.action_then_nuxt_login_required()) { return }
      const params = {}
      if (this.params.params_add_submit_key) {
        params[this.params.params_add_submit_key] = true
      }
      if (this.params.get_then_axios_get) {
        // URL を書き換えずにこっそり GET したい場合
        this.$sound.play_click()
        const new_params = this.new_params_create(params)
        this.$axios.$get(this.current_api_path, {params: new_params}).then(params => this.params_receive(params))
      } else {
        // $router.push でクエリ引数を変更することで再度 fetch() が実行したい場合
        this.router_push(params)
      }
    },

    post_handle() {
      if (this.action_then_nuxt_login_required()) { return }
      const new_params = this.new_params_create()
      this.$axios.$post(this.current_api_path, new_params).then(params => this.params_receive(params))
    },

    router_push(params = {}) {
      const new_params = this.new_params_create(params)
      this.browser_query_delete(new_params) // ブラウザ上で表示させたくないパラメータを削除する(new_params を破壊する)
      this.$router.push({query: new_params}, () => {
        this.debug_alert("Navigation succeeded")
        this.$sound.play_click()
      }, () => {
        this.debug_alert("Navigation failed")
        if (this.params.router_push_failed_then_fetch) {
          this.$sound.play_click()
          this.$fetch()
        } else {
          // this.toast_ok(`もう${this.params.button_label}しました`)
        }
      })
      // ここで $fetch を呼ぶと $route.query の更新より前に呼ばれてしまう
      // ブロックの中で呼ぶのが正しい
    },

    // ブラウザで見える GET パラメータを隠す
    // params 自体を破壊する
    // これによって気軽に直リンクされることがなくなる
    browser_query_delete(params) {
      this.params.form_parts.forEach(e => {
        if (e.hidden_on_query) {
          delete params[e.key]
        }
      })
    },

    action_then_nuxt_login_required() {
      if (this.params["button_with_nuxt_login_required"]) {
        if (this.nuxt_login_required()) { return true }
      }
    },

    // API側で判定した方がいい？ → テーブル内のTDなど最適に判定する → ビューで判定であっている
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
        if ("_component" in value) {
          return "value_type_is_component"
        }
        if ("_nuxt_link" in value) {
          return "value_type_is_nuxt_link"
        }
        if ("_link_to" in value) {
          return "value_type_is_link_to"
        }
        if ("_v_text" in value) {
          return "value_type_is_v_text"
        }
        if ("_pre" in value) {
          return "value_type_is_pre"
        }
        if ("_autolink" in value) {
          return "value_type_is_autolink"
        }
        return "value_type_is_any_hash"
      }
      return "value_type_is_unknown"
    },

    label_value_array(value) {
      if (Array.isArray(value)) {
        return value.map(e => [e, e])
      } else if (_.isPlainObject(value)) {
        return Object.entries(value)
      } else {
        return [[value, value]]
      }
    },

    type_to_component(form_part) {
      if (form_part.type === "radio_button") {
        return "b-radio-button"
      } else if (form_part.type === "checkbox_button") {
        return "b-checkbox-button"
      } else {
        throw new Error("must not happen")
      }
    },
  },
  computed: {
    current_qs_group() { return this.qs_group_key ?? this.$route.params.qs_group_key },
    current_qs_key()   { return this.qs_page_key   ?? this.$route.params.qs_page_key },
    current_api_path() { return `/api/bin/${this.current_qs_group ?? '__qs_group_key_is_blank__'}/${this.current_qs_key ?? '__qs_page_key_is_blank__'}.json` },
    meta()             { return this.params ? this.params.meta : null                                                                  },
    visible_form_parts_exist_p() { return this.params.form_parts.some(e => e.type !== "hidden") } // 目に見えるフォームパーツが存在するか？
  },
}
</script>

<style lang="sass">
.QuickScriptView
  .MainSection.section
    +mobile
      padding: 1.5rem 0.75rem
    +tablet
      padding: 1.75rem 0rem

  .container
    +mobile
      padding: 0

.STAGE-development
  .QuickScriptView
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
