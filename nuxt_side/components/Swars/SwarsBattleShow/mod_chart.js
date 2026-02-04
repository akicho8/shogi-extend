import { TimeChartVariantInfo } from "./time_chart_variant_info.js"
import { TimeChartZoomInfo    } from "./time_chart_zoom_info.js"

export const mod_chart = {
  computed: {
    TimeChartVariantInfo()    { return TimeChartVariantInfo                                         },
    time_chart_variant_info() { return this.TimeChartVariantInfo.fetch(this.time_chart_variant_key) },

    TimeChartZoomInfo()       { return TimeChartZoomInfo                                            },
    time_chart_zoom_info()    { return this.TimeChartZoomInfo.fetch(this.time_chart_zoom_key)       },

    current_source()          { return this.record.time_chart_params[this.time_chart_variant_info.key] },
  },
}
