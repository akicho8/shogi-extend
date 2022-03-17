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
                option(:value="null") 指定なし
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
  // watch: {
  //   "$route.query": "$fetch",
  // },
  // watch: {
  //   // "$route.query": "$fetch",
  //   // rule_key() {
  //   //   this.$router.push({query: {rule_key: this.rule_key}}, () => {
  //   //     this.clog("query に変化があったので watch 経由で $fetch が呼ばれる")
  //   //   }, () => {
  //   //     this.clog("query に変化がないので watch 経由で $fetch が呼ばれない。ので自分で呼ぶ")
  //   //     this.$fetch()
  //   //   })
  //   // },
  // },
  fetchOnServer: false,
  fetch() {
    this.rule_key = this.rule_key ?? this.$route.query.rule_key ?? "all"
    this.xtag = this.xtag ?? this.$route.query.xtag

    // if (this.present_p(this.rule_key)) {
    //   if (this.rule_key != "all") {
    //     this.rule_key = "all"
    //     this.toast_warn("データベースが固まるのでルール別の集計はできません")
    //   }
    // }

    const params = {
      ...this.$route.query,
      rule_key: this.rule_key,
      xtag: this.xtag,
      key: "grade",
    }
    // console.log(params)

    // console.log(`rule_key: ${this.rule_key}`)
    // console.log(new_params)

    // if (this.blank_p(params.query)) {
    //   params.query = this.swars_search_default_key_get()
    // }

    // if (this.blank_p(params.per)) {
    //   if (this.per_info.key !== this.base.ParamInfo.fetch("per_key").default_for(this.base)) {
    //     params.per = this.per_info.per
    //   }
    // }

    // if (this.blank_p(params.per)) {
    //   // if (this.per_info.key !== this.base.ParamInfo.fetch("per_key").default_for(this.base)) {
    //   params.per = this.per_info.per
    //   // }
    // }

    // params = this.pc_url_params_clean(params)
    // this.ga_process(params)

    // Number(params.per || 1)

  //   const xi = await $axios.$get("/api/swars_histogram.json", {params: new_params})
  //   return {
  //     xi: xi,
  //     rule_key: xi.rule_key,
  //   }

    return this.$axios.$get("/api/swars_histogram.json", {params}).then(xi => {
      this.xi = xi

      if (this.present_p(this.$route.query) && this.development_p) {
        if (this.xi.real_total_count === 0) {
          this.toast_warn("なんも見つかりませんでした")
        }
      }

      // this.rule_key = xi.rule_key
      // this.rails_session_side_copy_to_user_keys_if_blank()
      //
      // // なかから nuxt-link したとき $fetch が呼ばれるが、
      // // this.query は前の状態なので更新する
      // this.query = this.xi.query
      // this.user_keys_update_by_query()
      // // this.query = this.$route.query.query
      //
      // this.xnotice_run_all(this.xi)
      //
      // this.tiresome_alert_check()
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

  // watchQuery: ["max", "rule_key"],
  // async asyncData({$axios, params, query}) {
  //   // http://localhost:3000/api/swars_histogram.json
  //   let new_params = {
  //     ...params,
  //     ...query,
  //     key: "grade",
  //   }
  //   const xi = await $axios.$get("/api/swars_histogram.json", {params: new_params})
  //   return {
  //     xi: xi,
  //     rule_key: xi.rule_key,
  //   }
  // },
  mounted() {
    // this.ga_click(`段級分布`)
    this.ga_click("将棋ウォーズ棋力分布")
  },
  // created() {
  //   const unwatch = this.$watch(() => [this.foo, this.bar], () => this.share_update(), {deep: true})
  //   unwatch()
  // },
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
