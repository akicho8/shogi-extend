<template lang="pug">
client-only
  .swars-histograms-grade
    DebugBox.is-hidden-mobile(v-if="development_p")
      p rule_key: {{rule_key}}
      p xtag: {{xtag}}
      p query: {{$route.query}}

    FetchStateErrorMessage(:fetchState="$fetchState")
    b-loading(:active="$fetchState.pending")

    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-histograms-grade', params: {key: $route.params.key}}")
          | 将棋ウォーズ棋力分布

    MainSection(v-if="xi")
      .container
        SwarsHistogramNavigation(:config="xi")
        //- .is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
        .columns.is-multiline.is-variable.is-0-mobile
          .column(v-if="development_p || true")
            SimpleRadioButtons.xfield_block(:base="base" model_name="RuleSelectInfo" var_name="rule_key" custom-class="is-small" v-if="rule_key")
          .column(v-if="development_p || true")
            //- https://buefy.org/documentation/field#combining-addons-and-groups
            b-field.xfield_block(label="戦法等" custom-class="is-small")
              b-select(v-model="xtag" @input="xtag_input_handle")
                option(value="") 指定なし
                option(v-for="e in xi.xtag_select_names" :value="e") {{e}}
        .columns.is-vcentered.is-multiline.xform_block
          .column
            //- b-field.submit_field2
            b-field.xfield_block(custom-class="is-small")
              b-button.has-text-weight-bold(@click="submit_handle" type="is-primary") 集計
          .column
            nav.level.is-mobile
              .level-item.has-text-centered
                div
                  .heading 直近の実サンプル数
                  .title {{xi.sample_count}}
              .level-item.has-text-centered
                div
                  .heading 絞り込み後の件数
                  .title {{xi.real_total_count}}

        .columns.is-centered
          .column.is-7
            CustomChart.is-unselectable(:params="xi.custom_chart_params")
        .columns
          .column
            b-table(
              :data="xi.records"
              :mobile-cards="false"
              hoverable
              )
              b-table-column(v-slot="{row}" field="grade.priority"  label="棋力" sortable) {{row.grade.key}}
              b-table-column(v-slot="{row}" field="ratio"           label="割合" numeric sortable) {{float_to_perc(row.ratio, 2)}} %
              b-table-column(v-slot="{row}" field="count"           label="人数" numeric sortable) {{row.count}}
              //- b-table-column(v-slot="{row}" field="deviation_score" label="偏差値" numeric sortable :visible="development_p") {{number_round(row.deviation_score)}}

    DebugPrint(v-if="development_p")
    DebugPre(v-if="development_p && xi")
      | {{xi.records}}
</template>

<script>
import { RuleSelectInfo  } from "./models/rule_select_info.js"

export default {
  name: "swars-histograms-grade",
  data() {
    return {
      xi: null,
      rule_key: null,
      xtag: null,
    }
  },
  fetchOnServer: false,
  fetch() {
    this.rule_key = this.rule_key ?? this.$route.query.rule_key ?? "all"
    this.xtag = this.xtag ?? this.$route.query.xtag ?? ""

    const params = {
      ...this.$route.query,
      rule_key: this.rule_key,
      xtag: this.xtag,
      key: "grade",
    }

    return this.$axios.$get("/api/swars_histogram.json", {params}).then(xi => {
      this.xi = xi

      if (this.present_p(this.$route.query) || this.development_p) {
        const body = [
          ...Object.values(this.$route.query),
          this.xi.sample_count,
          this.xi.real_total_count,
          location.href,
        ].join(" ")
        this.remote_notify({emoji: ":CHART:", subject: "棋力分布", body: body})
      }

      if (this.present_p(this.$route.query) && this.development_p) {
        if (this.xi.real_total_count === 0) {
          this.toast_warn("なんも見つかりませんでした")
        }
      }
    })
  },
  methods: {
    router_push(params) {
      params = {...this.url_params, ...params}
      params = this.hash_compact_if_null(params)
      this.$router.push({name: "swars-histograms-grade", query: params})
      this.$fetch()
    },
    submit_handle() {
      this.sound_play_click()
      this.router_push({})
    },
    xtag_input_handle(v) {
      this.sound_play_click()
      this.talk(v || "指定なし")
    },
  },

  mounted() {
    this.ga_click("将棋ウォーズ棋力分布")
  },
  computed: {
    meta() {
      return {
        title: `将棋ウォーズ棋力分布`,
        og_description: "",
        og_image_key: "swars-histograms-attack",
      }
    },
    RuleSelectInfo() { return RuleSelectInfo },
    base() { return this },

    url_params() {
      return {
        rule_key: this.rule_key,
        xtag: this.xtag,
        max: this.$route.query.max,
      }
    },
  },
}
</script>

<style lang="sass">
.swars-histograms-grade
  .MainSection
    padding-top: 1.7rem

.STAGE-development
  .swars-histograms-grade
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
