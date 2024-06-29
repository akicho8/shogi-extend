<template lang="pug">
.QuickScriptShow
  b-loading(:active="$fetchState.pending")
  template(v-if="params")
    .title(v-if="params.meta.title")
      | {{params.meta.title}}
    .section
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

    div(v-if="params.get_button")
      b-button.submit_handle(@click="submit_handle" type="is-primary") {{params.button_label}}

    | Response:
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

    hr
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
      attributes: {},
      params: null,
    }
  },
  watch: {
    "$route.query": "$fetch",
  },
  fetchOnServer: false,
  fetch() {
    return this.$axios.$get(`/api/quick_scripts/${this.$route.params.id}`, {params: this.$route.query}).then(params => {
      // 受けとる
      this.params = params

      // 最優先でリダイレクトする
      if (Gs.present_p(params.body["redirect_to"])) {
        window.location.href = params.body["redirect_to"]
        return
      }

      // 初期値を埋める
      this.params.form_parts.forEach(form_part => {
        this.$set(this.attributes, form_part["key"], form_part["default"])
      })
    })
  },
  created() {
  },
  beforeMount() {
  },
  mounted() {
  },
  methods: {
    attr_value(form_part) {
      return this.attributes[form_part.key]
    },
    attr_update(form_part, value) {
      this.$set(this.attributes, form_part.key, value)
    },
    submit_handle() {
      const router_options = {name: "script-id", params: {id: this.params["id"]}, query: this.attributes}
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
  __css_keep__: 0
</style>
