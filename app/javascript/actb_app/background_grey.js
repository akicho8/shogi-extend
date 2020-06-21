export const background_grey = {
  created() {
    this.html_background_color_set("hsl(0,0%,96%)") // $white-ter
  },
  beforeDestroy() {
    this.html_background_color_set()
  },
}
