// 下のチャート関連

export const app_chart = {
  data() {
    return {
      xy_chart_rule_key: null,
      xy_chart_scope_key: null,
    }
  },

  watch: {
    xy_chart_rule_key()  { this.chart_data_get_and_show() },
    xy_chart_scope_key() { this.chart_data_get_and_show() },
  },

  methods: {
    chart_data_get_and_show() {
      const params = {
        xy_chart_scope_key: this.xy_chart_scope_key,
        xy_chart_rule_key:  this.xy_chart_rule_key,
      }
      this.$axios.$get("/api/xy.json", {params: params}).then(data => {
        this.$refs.XyMasterChart.chart_update_from_axios(data)
      })
    },
  },

  computed: {
    curent_xy_chart_scope() {
      return this.XyChartScopeInfo.fetch(this.xy_chart_scope_key)
    },
  },
}
