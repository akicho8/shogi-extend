// ・合わせて ../components/models/global_var_accessor.js でメソッドを公開する
// ・グローバル変数の基本的な定義だけにしてクラスのようには書くな

import { VolumeConfig } from "@/components/models/volume_config.js"

export const state = () => ({
  g_var1: 0,
  g_talk_volume_scale: VolumeConfig.default_scale,
  g_common_volume_scale: VolumeConfig.default_scale,
  g_toast_key: null,
})

export const getters = {
  g_var1_get(state) {
    return state.g_var1
  },
  g_talk_volume_scale(state) {
    return state.g_talk_volume_scale
  },
  g_common_volume_scale(state) {
    return state.g_common_volume_scale
  },
  g_toast_key(state) {
    return state.g_toast_key
  },
}

export const mutations = {
  __g_var1_set(state, payload) {
    state.g_var1 = payload
  },
  __g_talk_volume_scale_set(state, payload) {
    state.g_talk_volume_scale = payload
  },
  __g_common_volume_scale_set(state, payload) {
    state.g_common_volume_scale = payload
  },
  __g_toast_key_set(state, payload) {
    state.g_toast_key = payload
  },
}

export const actions = {
}
