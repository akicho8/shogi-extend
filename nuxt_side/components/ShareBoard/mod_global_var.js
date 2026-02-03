export const mod_global_var = {
  beforeDestroy() {
    this.g_volume_talk_user_scale_reset()
    this.g_volume_common_user_scale_reset()
    this.g_toast_key_reset()
  },
  watch: {
    volume_talk_user_scale(v)   { this.g_volume_talk_user_scale   = v },
    volume_common_user_scale(v) { this.g_volume_common_user_scale = v },
    toast_key(v)           { this.g_toast_key           = v },
  },
}
