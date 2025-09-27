// ・合わせて ../plugins/my_common_mixin.js でメソッドを公開する
// ・グローバル変数の基本的な定義だけにしてクラスのようには書くな

import { VueTalkConfig } from "@/plugins/vue_talk_config.js"

export const state = () => ({
  g_var1: 0,
  g_talk_volume_scale: VueTalkConfig.VOLUME_SCALE,
})

export const getters = {
  g_var1_get(state) {
    return state.g_var1
  },
  g_talk_volume_scale(state) {
    return state.g_talk_volume_scale
  },
}

export const mutations = {
  g_var1_set(state, payload) {
    state.g_var1 = payload
  },
  __g_talk_volume_scale_set(state, payload) {
    state.g_talk_volume_scale = payload
  },
}

export const actions = {
}
