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
        SwarsHistogramNavigation(:xi="xi")
        //- .is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
        .columns.is-multiline.is-variable.is-0-mobile
          .column(v-if="development_p || true")
            SimpleRadioButton.xfield_block(:base="base" model_name="RuleSelectInfo" var_name="rule_key" custom-class="is-small" v-if="rule_key")
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
          SwarsHistogramSampleCount(:xi="xi")
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
              b-table-column(v-slot="{row}" field="階級値"   label="棋力" sortable) {{row["階級"]}}
              b-table-column(v-slot="{row}" field="度数"    label="人数" numeric sortable) {{row["度数"]}}
              b-table-column(v-slot="{row}" field="相対度数" label="割合" numeric sortable)
                | {{$gs.floatx100_percentage(row["相対度数"] ?? 0, 2)}} %
              b-table-column(v-slot="{row}" field="階級値" label="階級値" numeric sortable :visible="development_p")
                | {{$gs.number_round_s(row["階級値"])}}
              b-table-column(v-slot="{row}" field="累計相対度数"   label="上位" numeric sortable)
                | {{$gs.floatx100_percentage(row["累計相対度数"] ?? 0, 2)}} %
              b-table-column(v-slot="{row}" field="基準値"   label="基準値" numeric sortable :visible="development_p")
                template(v-if="row['基準値']")
                  | {{$gs.number_round_s(row["基準値"], 2)}}
              b-table-column(v-slot="{row}" field="偏差値"   label="偏差値" numeric sortable)
                template(v-if="row['偏差値']")
                  | {{$gs.number_round_s(row["偏差値"])}}
        .columns.is-vcentered.is-multiline.xform_block(v-if="xi['標準偏差']")
          .column
            nav.level.is-mobile
              .level-item.has-text-centered(v-if="development_p")
                div
                  .heading 平均
                  .title {{$gs.number_round_s(xi["平均"], 2)}}
              .level-item.has-text-centered
                div
                  .heading 不偏分散
                  .title {{$gs.number_round_s(xi["不偏分散"], 2)}}
              .level-item.has-text-centered
                div
                  .heading 標準偏差
                  .title {{$gs.number_round_s(xi["標準偏差"], 2)}}
              .level-item.has-text-centered
                div
                  .heading 基準値平均
                  .title {{$gs.number_round_s(xi["基準値平均"], 2)}}
        SwarsHistogramProcessedSec(:xi="xi")

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

      if (this.$gs.present_p(this.$route.query) && this.development_p) {
        const body = [
          ...Object.values(this.$route.query),
          this.xi.sample_count,
          this.xi.real_total_count,
          location.href,
        ].join(" ")
        this.app_log({emoji: ":CHART:", subject: "棋力分布", body: body})
      }

      if (this.$gs.present_p(this.$route.query) && this.development_p) {
        if (this.xi.real_total_count === 0) {
          this.toast_warn("なんも見つかりませんでした")
        }
      }
    })
  },
  methods: {
    router_push(params) {
      params = {...this.url_params, ...params}
      params = this.$gs.hash_compact(params)
      this.$router.push({name: "swars-histograms-grade", query: params})
      this.$fetch()
    },
    submit_handle() {
      this.$sound.play_click()
      this.router_push({})
    },
    xtag_input_handle(v) {
      this.$sound.play_click()
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
