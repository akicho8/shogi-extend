export const mod_global_var = {
  beforeDestroy() {
    this.g_talk_volume_scale_reset()
    this.g_common_volume_scale_reset()
    this.g_toast_key_reset()
  },
  watch: {
    talk_volume_scale(v)   { this.g_talk_volume_scale   = v },
    common_volume_scale(v) { this.g_common_volume_scale = v },
    toast_key(v)           { this.g_toast_key           = v },
  },
}
