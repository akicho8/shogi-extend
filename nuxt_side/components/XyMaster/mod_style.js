export const mod_style = {
  methods: {
    // スタイルを初期値に戻す
    style_default_handle() {
      this.sfx_click()

      this.touch_board_width = this.ls_default.touch_board_width
      this.xy_grid_stroke    = this.ls_default.xy_grid_stroke
      this.xy_grid_color     = this.ls_default.xy_grid_color
      this.xy_grid_star_size = this.ls_default.xy_grid_star_size
      this.xy_piece_opacity    = this.ls_default.xy_piece_opacity

      this.ghost_preset_key  = this.ls_default.ghost_preset_key
    },
  },
  computed: {
    component_style() {
      return {
        "--touch_board_width": this.touch_board_width,
        "--xy_grid_stroke":    this.xy_grid_stroke,
        "--xy_grid_color":     this.xy_grid_color,
        "--xy_grid_star_size": this.xy_grid_star_size,
        "--xy_piece_opacity":  this.xy_piece_opacity,
      }
    },
  },
}
