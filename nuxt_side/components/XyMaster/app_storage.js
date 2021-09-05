import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
    }
  },
  beforeMount() {
    this.ls_setup()
  },
  computed: {
    //////////////////////////////////////////////////////////////////////////////// for ls_support_mixin
    // |------------------+----------------------------------------|
    // | "xy_master"      | stopwatch のライブラリを使っていたころ |
    // | "new_xy_master"  | xy プレフィクスついていたころ          |
    // | "new_xy_master2" | xy プレフィクスついてない現状          |
    // |------------------+----------------------------------------|
    ls_storage_key() {
      return "new_xy_master2"
    },
    ls_default() {
      return {
        rule_key:        this.default_rule_key,
        chart_rule_key:  this.default_rule_key,
        scope_key:       "scope_today",
        chart_scope_key: "chart_scope_recently",
        entry_name:         this.current_entry_name,
        current_pages:      {},
        touch_board_width:  0.95,
        xy_grid_stroke:     1.0,
        xy_grid_color:    0.0,
        xy_grid_star_size:    16,
      }
    },
  },
}
