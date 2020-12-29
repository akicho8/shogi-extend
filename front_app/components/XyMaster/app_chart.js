// 下のチャート関連

export const app_chart = {
  data() {
    return {
      chart_rule_key: null,
      chart_scope_key: null,
    }
  },

  watch: {
    chart_rule_key()  { this.chart_data_get_and_show() },
    chart_scope_key() { this.chart_data_get_and_show() },
  },

  methods: {
    chart_data_get_and_show() {
      const params = {
        chart_scope_key: this.chart_scope_key,
        chart_rule_key:  this.chart_rule_key,
      }
      this.$axios.$get("/api/xy_master/time_records.json", {params: params}).then(data => {
        this.$refs.XyMasterChart.chart_update_from_axios(data)
      })
    },
  },

  computed: {
    curent_chart_scope() {
      return this.ChartScopeInfo.fetch(this.chart_scope_key)
    },
  },
}
