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
      b-button.submit_handle(@click="submit_handle" type="is-primary") 実行

    | Response:
    template(v-if="false")
    template(v-else-if="data_layout === 'table'")
      b-table(
        :data="params.body"
        )
        template(v-for="column_name in column_names")
          b-table-column(v-slot="{row}" :field="column_name" :label="column_name")
            template(v-if="false")
            template(v-else-if="value_type(row[column_name]) === 'url'")
              div(v-html="$gs.auto_link(row[column_name])")
            template(v-else)
              | {{row[column_name]}}
    template(v-else)
      pre
       | {{params.body}}

    hr
    | {{attributes}}
    hr
    | {{attributes.lhv}}
    hr
    | data_layout = {{data_layout}}
    | {{params.body}}

    //- DebugBox.is-hidden-mobile(v-if="development_p")
    //-   | {{params}}

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
  fetchOnServer: true,
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
      const router_options = {name: "script-id", params: {id: this.params["id"]}, query: this.current_query}
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
          return "url"
        }
      }
    },

  },
  computed: {
    current_query() { return this.attributes },
    data_layout() {
      if (this.params) {
        if (Array.isArray(this.params.body)) {
          if (_.isPlainObject(this.params.body[0])) {
            return "table"
          } else {
            return "string"
          }
        } else {
          return "string"
        }
      }
    },

    column_names() {
      if (this.data_layout === "table") {
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
